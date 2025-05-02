// Player state
import 'package:music_player/models/song.dart';

class PlayerState {
  final List<Song> playlist;
  final List<Song> originalPlaylist;
  final int currentIndex;
  final bool isCompleted;
  final bool isShuffled;
  final bool isRepeatOn;
  final Duration currentPosition;
  final Duration duration;
  final bool isLoading;

  PlayerState({
    this.playlist = const [],
    this.originalPlaylist = const [],
    this.currentIndex = 0,
    this.isCompleted = false,
    this.isShuffled = false,
    this.isRepeatOn = false,
    this.currentPosition = Duration.zero,
    this.duration = Duration.zero,
    this.isLoading = false,
  });

  Song? get currentSong => playlist.isNotEmpty ? playlist[currentIndex] : null;

  PlayerState copyWith({
    List<Song>? playlist,
    List<Song>? originalPlaylist,
    int? currentIndex,
    bool? isCompleted,
    bool? isShuffled,
    bool? isRepeatOn,
    Duration? currentPosition,
    Duration? duration,
    bool? isLoading,
  }) {
    return PlayerState(
      playlist: playlist ?? this.playlist,
      originalPlaylist: originalPlaylist ?? this.originalPlaylist,
      currentIndex: currentIndex ?? this.currentIndex,
      isCompleted: isCompleted ?? this.isCompleted,
      isShuffled: isShuffled ?? this.isShuffled,
      isRepeatOn: isRepeatOn ?? this.isRepeatOn,
      currentPosition: currentPosition ?? this.currentPosition,
      duration: duration ?? this.duration,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
