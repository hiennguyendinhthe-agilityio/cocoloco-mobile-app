/// Generic paginated response envelope aligned with FastAPI's PageResponse[T]
class PaginatedResponse<T> {
  final List<T> items;
  final int total;
  final int page;
  final int size;
  final int pages;

  const PaginatedResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.size,
    required this.pages,
  });

  /// True if there are more pages available to fetch
  bool get hasMore => page < pages;

  /// Empty initial paginated state
  const PaginatedResponse.empty()
      : items = const [],
        total = 0,
        page = 1,
        size = 10,
        pages = 0;

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> itemJson) itemParser,
  ) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    final items = rawItems
        .map((item) => itemParser(item as Map<String, dynamic>))
        .toList();
    final total = json['total'] as int? ?? items.length;
    final page = json['page'] as int? ?? 1;
    final size = json['size'] as int? ?? (items.isNotEmpty ? items.length : 10);
    final pages = json['pages'] as int? ??
        (total == 0 ? 0 : (total / (size > 0 ? size : 1)).ceil());

    return PaginatedResponse<T>(
      items: items,
      total: total,
      page: page,
      size: size,
      pages: pages,
    );
  }
}
