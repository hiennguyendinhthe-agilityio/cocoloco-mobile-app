import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            Obx(() => Text(
                  authController.username.value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            const SizedBox(height: 8),
            const Text(
              'user@example.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Profile'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to edit profile screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.security),
              title: const Text('Security'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to security settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notification Preferences'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to notification preferences
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                authController.logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sign in to continue',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 48),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    authController.login(
                      usernameController.text,
                      passwordController.text,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Obx(() {
                if (authController.isBiometricAvailable.value) {
                  return Center(
                    child: Column(
                      children: [
                        Text(
                          'lbl_or_sign_in_with'.tr,
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        IconButton(
                          onPressed: () {
                            authController.loginWithBiometrics();
                          },
                          icon: const Icon(
                            Icons.fingerprint,
                            size: 40,
                          ),
                          color: Theme.of(context).primaryColor,
                        ),
                        const Text(
                          'Fingerprint',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}

// Background message handler for Firebase Cloud Messaging
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Set up background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize controllers
  Get.put(AuthController());
  Get.put(NotificationController());
  Get.put(DeepLinkController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Secure App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF121212),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class AuthController extends GetxController {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final RxBool isLoggedIn = false.obs;
  final RxBool isBiometricAvailable = false.obs;
  final RxBool isAuthenticating = false.obs;
  final RxString username = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkBiometricAvailability();
    checkLoginStatus();
  }

  Future<void> checkBiometricAvailability() async {
    try {
      // Check if biometrics are available
      final canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics;
      final canAuthenticate =
          canAuthenticateWithBiometrics || await _localAuth.isDeviceSupported();

      isBiometricAvailable.value = canAuthenticate;

      if (canAuthenticate) {
        // Get available biometrics
        final availableBiometrics = await _localAuth.getAvailableBiometrics();
        debugPrint('Available biometrics: $availableBiometrics');
      }
    } on PlatformException catch (e) {
      debugPrint('Error checking biometric availability: $e');
      isBiometricAvailable.value = false;
    }
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('username');

    if (savedUsername != null && savedUsername.isNotEmpty) {
      username.value = savedUsername;
      isLoggedIn.value = true;
    }
  }

  Future<bool> authenticateWithBiometrics() async {
    if (!isBiometricAvailable.value) {
      Get.snackbar(
        'Error',
        'Biometric authentication is not available on this device',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    isAuthenticating.value = true;

    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to access the app',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      isAuthenticating.value = false;

      if (authenticated) {
        // If user is already logged in, navigate to home
        if (isLoggedIn.value) {
          Get.offAll(() => const HomeScreen());
        }
      }

      return authenticated;
    } on PlatformException catch (e) {
      isAuthenticating.value = false;

      if (e.code == auth_error.notAvailable) {
        Get.snackbar(
          'Error',
          'Biometric authentication is not available on this device',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (e.code == auth_error.notEnrolled) {
        Get.snackbar(
          'Error',
          'No biometrics enrolled on this device',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          'Biometric authentication failed: ${e.message}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }

      return false;
    }
  }

  Future<void> login(String username, String password) async {
    // In a real app, you would validate credentials against a backend
    // For this example, we'll just check if username and password are not empty
    if (username.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Username and password are required',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Save login state
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);

    this.username.value = username;
    isLoggedIn.value = true;

    Get.offAll(() => const HomeScreen());
  }

  Future<void> loginWithBiometrics() async {
    if (await authenticateWithBiometrics()) {
      if (!isLoggedIn.value) {
        Get.snackbar(
          'Error',
          'Please log in with username and password first',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');

    username.value = '';
    isLoggedIn.value = false;

    Get.offAll(() => const LoginScreen());
  }
}

class NotificationController extends GetxController {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final NotificationService _notificationService = NotificationService();
  final RxList<AppNotification> notifications = <AppNotification>[].obs;
  final RxBool permissionGranted = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    // Request permission
    await requestPermission();

    // Get FCM token
    final token = await _firebaseMessaging.getToken();
    debugPrint('FCM Token: $token');

    // Configure foreground message handling
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      if (message.notification != null) {
        debugPrint(
            'Message also contained a notification: ${message.notification}');

        // Add to notifications list
        final notification = AppNotification(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: message.notification!.title ?? 'New Notification',
          body: message.notification!.body ?? '',
          timestamp: DateTime.now(),
          read: false,
          data: message.data,
        );

        notifications.add(notification);

        // Show local notification
        _notificationService.showNotification(
          notification.id,
          notification.title,
          notification.body,
        );
      }
    });

    // Configure message handling when app is opened from terminated state
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        debugPrint(
            'App opened from terminated state with message: ${message.data}');
        _handleNotificationTap(message.data);
      }
    });

    // Configure message handling when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint(
          'App opened from background state with message: ${message.data}');
      _handleNotificationTap(message.data);
    });
  }

  Future<void> requestPermission() async {
    final settings = await _firebaseMessaging.requestPermission();

    permissionGranted.value =
        settings.authorizationStatus == AuthorizationStatus.authorized ||
            settings.authorizationStatus == AuthorizationStatus.provisional;

    debugPrint('User granted permission: ${permissionGranted.value}');
  }

  void _handleNotificationTap(Map<String, dynamic> data) {
    // Handle notification tap based on data
    // For example, navigate to a specific screen
    if (data.containsKey('screen')) {
      final screen = data['screen'];
      if (screen == 'profile') {
        // Navigate to profile screen
        // Get.to(() => ProfileScreen());
      } else if (screen == 'settings') {
        // Navigate to settings screen
        // Get.to(() => SettingsScreen());
      }
    }
  }

  void markAsRead(String id) {
    final index =
        notifications.indexWhere((notification) => notification.id == id);
    if (index != -1) {
      final notification = notifications[index];
      notifications[index] = AppNotification(
        id: notification.id,
        title: notification.title,
        body: notification.body,
        timestamp: notification.timestamp,
        read: true,
        data: notification.data,
      );
    }
  }

  void clearAll() {
    notifications.clear();
  }

  int get unreadCount =>
      notifications.where((notification) => !notification.read).length;
}

class DeepLinkController extends GetxController {
  StreamSubscription? _linkSubscription;
  final RxString currentLink = ''.obs;

  @override
  void onInit() {
    super.onInit();
    initAppLinks();
  }

  @override
  void onClose() {
    _linkSubscription?.cancel();
    super.onClose();
  }

  Future<void> initAppLinks() async {
    final appLinks = AppLinks();

    // Handle app opened from link when app was terminated
    try {
      final initialLink = await appLinks.getInitialLink();
      if (initialLink != null) {
        currentLink.value = initialLink.toString();
        handleDeepLink(initialLink.toString());
      }
    } catch (e) {
      // Handle exception
      debugPrint('Failed to get initial link: $e');
    }

    // Handle app opened from link when app was in background
    _linkSubscription = appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        currentLink.value = uri.toString();
        handleDeepLink(uri.toString());
      }
    }, onError: (error) {
      // Handle exception
      debugPrint('Error getting link: $error');
    });
  }

  void handleDeepLink(String link) {
    debugPrint('Handling deep link: $link');

    // Parse the link and navigate accordingly
    // Example: myapp://profile
    if (link.contains('profile')) {
      Get.to(() => const ProfileScreen());
    } else if (link.contains('settings')) {
      Get.to(() => const SettingsScreen());
    } else if (link.contains('notifications')) {
      Get.to(() => const NotificationScreen());
    }

    // You can also parse parameters from the link
    // Example: myapp://product?id=123
    final uri = Uri.parse(link);
    if (uri.path.contains('product')) {
      final productId = uri.queryParameters['id'];
      if (productId != null) {
        // Navigate to product details
        // Get.to(() => ProductDetailsScreen(productId: productId));
      }
    }
  }
}

class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final bool read;
  final Map<String, dynamic> data;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.read,
    required this.data,
  });
}

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService() {
    _initialize();
  }

  Future<void> _initialize() async {
    // Initialize settings for Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Initialize settings for iOS
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    // Initialize settings for all platforms
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
        debugPrint('Notification tapped: ${response.payload}');
      },
    );
  }

  Future<void> showNotification(String id, String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'secure_app_channel',
      'Secure App Notifications',
      channelDescription: 'Notifications from Secure App',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      int.parse(id.hashCode.toString().substring(0, 9)),
      title,
      body,
      platformChannelSpecifics,
      payload: id,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthController _authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));

    if (_authController.isLoggedIn.value) {
      // If user is logged in, try to authenticate with biometrics
      if (_authController.isBiometricAvailable.value) {
        final authenticated =
            await _authController.authenticateWithBiometrics();
        if (authenticated) {
          Get.offAll(() => const HomeScreen());
        } else {
          Get.offAll(() => const LoginScreen());
        }
      } else {
        Get.offAll(() => const HomeScreen());
      }
    } else {
      Get.offAll(() => const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.security,
              size: 100,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 24),
            Text(
              'Secure App',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Biometrics • Notifications • Deep Links',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final NotificationController notificationController =
        Get.find<NotificationController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  Get.to(() => const NotificationScreen());
                },
              ),
              Obx(() {
                final unreadCount = notificationController.unreadCount;
                if (unreadCount > 0) {
                  return Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        unreadCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(() => Text(
                        'Welcome, ${authController.username.value}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      )),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Get.back();
                Get.to(() => const ProfileScreen());
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifications'),
              onTap: () {
                Get.back();
                Get.to(() => const NotificationScreen());
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Get.back();
                Get.to(() => const SettingsScreen());
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                authController.logout();
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.security,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 24),
              const Text(
                'Welcome to Secure App',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'This app demonstrates biometric authentication, push notifications, and deep linking.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              ElevatedButton.icon(
                onPressed: () {
                  Get.to(() => const ProfileScreen());
                },
                icon: const Icon(Icons.person),
                label: const Text('Go to Profile'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Get.to(() => const NotificationScreen());
                },
                icon: const Icon(Icons.notifications),
                label: const Text('View Notifications'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Get.to(() => const SettingsScreen());
                },
                icon: const Icon(Icons.settings),
                label: const Text('Settings'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationController notificationController =
        Get.find<NotificationController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              Get.dialog(
                AlertDialog(
                  title: const Text('Clear Notifications'),
                  content: const Text(
                      'Are you sure you want to clear all notifications?'),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        notificationController.clearAll();
                        Get.back();
                      },
                      child: const Text('Clear'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        final notifications = notificationController.notifications;

        if (notifications.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_off,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'No notifications yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            final dateFormat = DateFormat('MMM d, yyyy • h:mm a');

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: notification.read ? Colors.grey : Colors.blue,
                child: const Icon(
                  Icons.notifications,
                  color: Colors.white,
                ),
              ),
              title: Text(
                notification.title,
                style: TextStyle(
                  fontWeight:
                      notification.read ? FontWeight.normal : FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notification.body),
                  Text(
                    dateFormat.format(notification.timestamp),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              onTap: () {
                notificationController.markAsRead(notification.id);
              },
            );
          },
        );
      }),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final NotificationController notificationController =
        Get.find<NotificationController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const ListTile(
            title: Text('App Settings'),
            subtitle: Text('General app settings'),
            leading: Icon(Icons.settings),
          ),
          const Divider(),
          ListTile(
            title: const Text('Biometric Authentication'),
            subtitle: Obx(() => Text(
                  authController.isBiometricAvailable.value
                      ? 'Enabled'
                      : 'Not available on this device',
                )),
            leading: const Icon(Icons.fingerprint),
            trailing: Obx(() => Switch(
                  value: authController.isBiometricAvailable.value,
                  onChanged: (value) {
                    if (!value) {
                      Get.snackbar(
                        'Info',
                        'Biometric authentication cannot be disabled',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    } else {
                      authController.checkBiometricAvailability();
                    }
                  },
                )),
          ),
          ListTile(
            title: const Text('Push Notifications'),
            subtitle: Obx(() => Text(
                  notificationController.permissionGranted.value
                      ? 'Enabled'
                      : 'Disabled',
                )),
            leading: const Icon(Icons.notifications),
            trailing: Obx(() => Switch(
                  value: notificationController.permissionGranted.value,
                  onChanged: (value) {
                    if (value) {
                      notificationController.requestPermission();
                    } else {
                      Get.snackbar(
                        'Info',
                        'Please disable notifications in system settings',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                )),
          ),
          const Divider(),
          ListTile(
            title: const Text('About'),
            subtitle: const Text('App version and information'),
            leading: const Icon(Icons.info),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Secure App',
                applicationVersion: '1.0.0',
                applicationIcon: const Icon(
                  Icons.security,
                  size: 40,
                  color: Colors.blue,
                ),
                children: [
                  const Text(
                    'A Flutter app demonstrating biometric authentication, push notifications, and deep linking.',
                  ),
                ],
              );
            },
          ),
          ListTile(
            title: const Text('Privacy Policy'),
            subtitle: const Text('View our privacy policy'),
            leading: const Icon(Icons.privacy_tip),
            onTap: () {
              // Navigate to privacy policy
            },
          ),
          ListTile(
            title: const Text('Terms of Service'),
            subtitle: const Text('View our terms of service'),
            leading: const Icon(Icons.description),
            onTap: () {
              // Navigate to terms of service
            },
          ),
        ],
      ),
    );
  }
}
