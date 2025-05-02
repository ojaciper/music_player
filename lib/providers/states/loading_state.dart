// Loading state
class LoadingState {
  final bool isLoading;
  final String? error;

  LoadingState({this.isLoading = false, this.error});

  LoadingState copyWith({bool? isLoading, String? error}) {
    return LoadingState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
