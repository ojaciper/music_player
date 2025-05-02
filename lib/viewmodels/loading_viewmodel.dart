import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/providers/states/loading_state.dart';

class LoadingStateNotifier extends StateNotifier<LoadingState> {
  LoadingStateNotifier() : super(LoadingState());

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading, error: null);
  }

  void setError(String error) {
    state = state.copyWith(isLoading: false, error: error);
  }
}
