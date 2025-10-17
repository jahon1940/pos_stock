class PaginatedDto<T> {
  final List<T> results;
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final int count;
  final String? next;
  final String? previous;

  const PaginatedDto({
    required this.results,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.count,
    this.next,
    this.previous,
  });

  /// Фабричный метод для десериализации JSON
  factory PaginatedDto.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>)
        fromJsonT, // Функция для десериализации элементов
  ) {
    return PaginatedDto<T>(
      results: (json['results'] as List).map((e) => fromJsonT(e)).toList(),
      pageNumber: json['page_number'],
      pageSize: json['page_size'],
      totalPages: json['total_pages'],
      next: json['next'],
      previous: json['previous'],
      count: json['count'],
    );
  }

  PaginatedDto<T> copyWith({
    List<T>? results,
    int? pageNumber,
    int? pageSize,
    int? totalPages,
    int? count,
    String? next,
    String? previous,
  }) {
    return PaginatedDto<T>(
      results: results ?? this.results,
      pageNumber: pageNumber ?? this.pageNumber,
      pageSize: pageSize ?? this.pageSize,
      totalPages: totalPages ?? this.totalPages,
      count: count ?? this.count,
      next: next ?? this.next,
      previous: previous ?? this.previous,
    );
  }
}
