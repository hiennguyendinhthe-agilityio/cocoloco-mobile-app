import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../core/services/session_service.dart';
import '../core/theme/app_colors.dart';

class ClerkAuthResult {
  final String token;
  final String? email;
  final String? fullName;
  final String? avatarUrl;

  const ClerkAuthResult({
    required this.token,
    this.email,
    this.fullName,
    this.avatarUrl,
  });

  @override
  String toString() => 'ClerkAuthResult(email: $email, fullName: $fullName, avatarUrl: $avatarUrl)';
}

class ClerkWebViewScreen extends StatefulWidget {
  final String signInUrl;
  final bool? showSwitchAccount;

  const ClerkWebViewScreen({
    super.key,
    this.signInUrl = 'https://proud-rhino-8074.accounts.dev/sign-in',
    this.showSwitchAccount,
  });

  @override
  State<ClerkWebViewScreen> createState() => _ClerkWebViewScreenState();
}

class _ClerkWebViewScreenState extends State<ClerkWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
            // Inject script to continuously poll for Clerk session token and user metadata
            _startTokenPolling();
          },
        ),
      )
      ..addJavaScriptChannel(
        'ClerkChannel',
        onMessageReceived: (JavaScriptMessage message) {
          final raw = message.message;
          if (raw.isNotEmpty && raw != 'null') {
            ClerkAuthResult authResult;
            try {
              final decoded = jsonDecode(raw);
              if (decoded is Map<String, dynamic>) {
                authResult = ClerkAuthResult(
                  token: (decoded['token'] as String? ?? '').trim(),
                  email: decoded['email'] as String?,
                  fullName: decoded['fullName'] as String?,
                  avatarUrl: decoded['avatarUrl'] as String?,
                );
              } else {
                authResult = ClerkAuthResult(token: raw.trim());
              }
            } catch (_) {
              authResult = ClerkAuthResult(token: raw.trim());
            }

            if (authResult.token.isNotEmpty && mounted && Navigator.canPop(context)) {
              Navigator.pop(context, authResult);
            }
          }
        },
      )
      ..loadRequest(Uri.parse(widget.signInUrl));
  }

  void _startTokenPolling() {
    const String script = '''
      (function() {
        if (window._clerkPollStarted) return;
        window._clerkPollStarted = true;

        async function checkToken() {
          try {
            let token = null;
            let fullName = null;
            let email = null;
            let avatarUrl = null;

            if (window.Clerk) {
              if (window.Clerk.session) {
                try {
                  token = await window.Clerk.session.getToken();
                } catch (err) {}
              }

              const u = window.Clerk.user || (window.Clerk.session ? window.Clerk.session.user : null);
              if (u) {
                fullName = u.fullName || ([u.firstName, u.lastName].filter(Boolean).join(' ')) || null;
                avatarUrl = u.imageUrl || null;
                if (u.primaryEmailAddress && u.primaryEmailAddress.emailAddress) {
                  email = u.primaryEmailAddress.emailAddress;
                } else if (u.emailAddresses && u.emailAddresses.length > 0) {
                  email = u.emailAddresses[0].emailAddress;
                }
              }
            }

            if (!token) {
              const match = document.cookie.match(/__session=([^;]+)/);
              if (match && match[1] && match[1].length > 20) {
                token = match[1];
              }
            }

            if (token && token.length > 20) {
              ClerkChannel.postMessage(JSON.stringify({
                token: token,
                fullName: fullName,
                email: email,
                avatarUrl: avatarUrl
              }));
              return;
            }
          } catch (e) {
            console.error('Clerk poll error:', e);
          }
        }

        setInterval(checkToken, 800);
        checkToken();
      })();
    ''';
    _controller.runJavaScript(script);
  }

  @override
  Widget build(BuildContext context) {
    final showSwitch = widget.showSwitchAccount ?? SessionService.instance.hasLoggedOut;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign In',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: AppColors.textDark),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: showSwitch
            ? [
                TextButton.icon(
                  onPressed: () async {
                    await WebViewCookieManager().clearCookies();
                    await _controller.clearCache();
                    await _controller.reload();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Previous session cleared. You can now sign in with a new account.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.switch_account_rounded, size: 18, color: AppColors.primary),
                  label: const Text(
                    'Switch Account',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ]
            : null,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ),
        ],
      ),
    );
  }
}
