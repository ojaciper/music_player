import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/models/song.dart';
import 'package:music_player/providers/providers.dart';

class NowPlayingScreen extends ConsumerWidget {
  final Song song;
  const NowPlayingScreen({super.key, required this.song});

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerProvider);
    final currentSong = playerState.currentSong ?? song;
    final player = ref.watch(audioPlayerProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  const Text(
                    'NOW PLAYING',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
              const SizedBox(height: 24),
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.network(
                      currentSong.albumArt,
                      height: 260,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    if (playerState.isLoading)
                      Container(
                        height: 260,
                        width: double.infinity,
                        color: Colors.black54,
                        child: const Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.pink),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                currentSong.title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.center,
              ),
              Text(
                currentSong.artist,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.shuffle,
                      color: playerState.isShuffled ? Colors.pink : Colors.grey,
                      size: 24,
                    ),
                    onPressed: () =>
                        ref.read(playerProvider.notifier).toggleShuffle(),
                  ),
                  const SizedBox(width: 32),
                  IconButton(
                    icon: Icon(
                      Icons.repeat,
                      color: playerState.isRepeatOn ? Colors.pink : Colors.grey,
                      size: 24,
                    ),
                    onPressed: () =>
                        ref.read(playerProvider.notifier).toggleRepeat(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    _formatDuration(playerState.currentPosition),
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onHorizontalDragUpdate: (details) {
                        // Calculate how much to seek based on drag
                        final box = context.findRenderObject() as RenderBox;
                        final width = box.size.width;
                        final dragValue = details.delta.dx / width;
                        final duration =
                            playerState.duration.inSeconds.toDouble();
                        final seekSeconds = dragValue * duration;
                        ref
                            .read(playerProvider.notifier)
                            .seekByOffset(seekSeconds);
                      },
                      child: Slider(
                        value: playerState.currentPosition.inSeconds.toDouble(),
                        max: playerState.duration.inSeconds.toDouble(),
                        min: 0,
                        activeColor: Colors.pink,
                        inactiveColor: Colors.grey[800],
                        onChanged: (value) {
                          ref.read(playerProvider.notifier).seekTo(
                                Duration(seconds: value.toInt()),
                              );
                        },
                      ),
                    ),
                  ),
                  Text(
                    _formatDuration(playerState.duration),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous,
                        size: 36, color: Colors.white),
                    onPressed: () =>
                        ref.read(playerProvider.notifier).previous(),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Colors.pink, Colors.purple],
                      ),
                    ),
                    child: IconButton(
                      icon: playerState.isLoading
                          ? CircularProgressIndicator()
                          : Icon(
                              playerState.isCompleted
                                  ? Icons.replay
                                  : player.playing
                                      ? Icons.pause
                                      : Icons.play_arrow,
                              size: 40,
                              color: Colors.white,
                            ),
                      onPressed: () =>
                          ref.read(playerProvider.notifier).playPause(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next,
                        size: 36, color: Colors.white),
                    onPressed: () => ref.read(playerProvider.notifier).next(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
