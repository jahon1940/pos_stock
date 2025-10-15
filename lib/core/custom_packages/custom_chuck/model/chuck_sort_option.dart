///Available sort options in inspector UI.
library;
// ignore_for_file: prefer_single_quotes

enum ChuckSortOption {
  time,
  responseTime,
  responseCode,
  responseSize,
  endpoint,
}

extension ChuckSortOptionsExtension on ChuckSortOption {
  String get name {
    switch (this) {
      case ChuckSortOption.time:
        return "Create time (default)";
      case ChuckSortOption.responseTime:
        return "Response time";
      case ChuckSortOption.responseCode:
        return "Response code";
      case ChuckSortOption.responseSize:
        return "Response size";
      case ChuckSortOption.endpoint:
        return "Endpoint";
    }
  }
}
