enum StateStatus {
  initial,
  loading,
  loaded,
  error,
  success,
  loadingMore;

  bool get isInitial => this == StateStatus.initial;

  bool get isLoading => this == StateStatus.loading;

  bool get isLoaded => this == StateStatus.loaded;

  bool get isError => this == StateStatus.error;

  bool get isSuccess => this == StateStatus.success;

  bool get isLoadingMore => this == StateStatus.loadingMore;
}
