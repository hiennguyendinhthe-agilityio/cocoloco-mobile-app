import 'dart:io';

/// Overrides [HttpClient] to block all real network calls in tests.
///
/// If a test attempts to make a real HTTP request, it will fail fast
/// with a clear error rather than hanging or making flaky network calls.
///
/// Inspired by the pattern used in immich mobile test suite.
class MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _ThrowingHttpClient();
  }
}

class _ThrowingHttpClient implements HttpClient {
  static Never _notAllowed() {
    throw UnsupportedError(
      'Real HTTP calls are not allowed in unit/widget tests.\n'
      'Use mocks (mocktail) to stub network dependencies instead.',
    );
  }

  @override
  Future<HttpClientRequest> open(
    String method,
    String host,
    int port,
    String path,
  ) =>
      _notAllowed();

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) => _notAllowed();

  @override
  Future<HttpClientRequest> get(String host, int port, String path) =>
      _notAllowed();

  @override
  Future<HttpClientRequest> getUrl(Uri url) => _notAllowed();

  @override
  Future<HttpClientRequest> post(String host, int port, String path) =>
      _notAllowed();

  @override
  Future<HttpClientRequest> postUrl(Uri url) => _notAllowed();

  @override
  Future<HttpClientRequest> put(String host, int port, String path) =>
      _notAllowed();

  @override
  Future<HttpClientRequest> putUrl(Uri url) => _notAllowed();

  @override
  Future<HttpClientRequest> delete(String host, int port, String path) =>
      _notAllowed();

  @override
  Future<HttpClientRequest> deleteUrl(Uri url) => _notAllowed();

  @override
  Future<HttpClientRequest> patch(String host, int port, String path) =>
      _notAllowed();

  @override
  Future<HttpClientRequest> patchUrl(Uri url) => _notAllowed();

  @override
  Future<HttpClientRequest> head(String host, int port, String path) =>
      _notAllowed();

  @override
  Future<HttpClientRequest> headUrl(Uri url) => _notAllowed();

  @override
  bool autoUncompress = true;

  @override
  Duration? connectionTimeout;

  @override
  Duration idleTimeout = const Duration(seconds: 15);

  @override
  int? maxConnectionsPerHost;

  @override
  String? userAgent;

  @override
  void addCredentials(
    Uri url,
    String realm,
    HttpClientCredentials credentials,
  ) {}

  @override
  void addProxyCredentials(
    String host,
    int port,
    String realm,
    HttpClientCredentials credentials,
  ) {}

  @override
  set authenticate(
    Future<bool> Function(Uri url, String scheme, String? realm)? f,
  ) {}

  @override
  set authenticateProxy(
    Future<bool> Function(
      String host,
      int port,
      String scheme,
      String? realm,
    )?
    f,
  ) {}

  @override
  set badCertificateCallback(
    bool Function(X509Certificate cert, String host, int port)? callback,
  ) {}

  @override
  set findProxy(String Function(Uri url)? f) {}

  @override
  void close({bool force = false}) {}

  @override
  set connectionFactory(
    Future<ConnectionTask<Socket>> Function(
      Uri url,
      String? proxyHost,
      int? proxyPort,
    )?
    f,
  ) {}

  @override
  set keyLog(Function(String line)? callback) {}
}
