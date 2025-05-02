import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/providers/providers.dart';
import 'package:music_player/views/screens/now_playing_screen.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      ref.read(loadingStateProvider.notifier).setLoading(true);
      ref.read(songsProvider.notifier).fetchSongs('weeknd').then((_) {
        ref.read(loadingStateProvider.notifier).setLoading(false);
      }).catchError((error) {
        ref.read(loadingStateProvider.notifier).setError(error.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final loadingState = ref.watch(loadingStateProvider);
    final songs = ref.watch(songsProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final availableHeight = constraints.maxHeight;
              final carouselHeight =
                  availableHeight * 0.7; // 70% of available height

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'DISCOVER\nMUSIC',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 100),
                  loadingState.isLoading
                      ? const Expanded(
                          child: Center(child: CircularProgressIndicator()))
                      : loadingState.error != null
                          ? Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    loadingState.error!,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      ref
                                          .read(loadingStateProvider.notifier)
                                          .setLoading(true);
                                      ref
                                          .read(songsProvider.notifier)
                                          .fetchSongs('weeknd')
                                          .then((_) {
                                        ref
                                            .read(loadingStateProvider.notifier)
                                            .setLoading(false);
                                      }).catchError((error) {
                                        ref
                                            .read(loadingStateProvider.notifier)
                                            .setError(error.toString());
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.pink,
                                    ),
                                    icon: const Icon(Icons.refresh),
                                    label: const Text('Try Again'),
                                  ),
                                ],
                              ),
                            )
                          : songs.isEmpty
                              ? const Expanded(
                                  child: Center(
                                    child: Text(
                                      'No songs found. Tap "Fetch Songs" to load music.',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                )
                              : Expanded(
                                  child: Column(
                                    children: [
                                      CarouselSlider.builder(
                                        itemCount: songs.length,
                                        itemBuilder:
                                            (context, index, pageIndex) {
                                          final song = songs[index];
                                          return SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    ref
                                                        .read(playerProvider
                                                            .notifier)
                                                        .setPlaylist(
                                                          songs,
                                                          startIndex: index,
                                                        );
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            NowPlayingScreen(
                                                          song: song,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            24),
                                                    child: Image.network(
                                                      song.albumArt,
                                                      height:
                                                          carouselHeight * 0.6,
                                                      width: double.infinity,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 16),
                                                Text(
                                                  song.title,
                                                  style: const TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  song.artist,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        options: CarouselOptions(
                                          height: carouselHeight,
                                          viewportFraction: 0.75,
                                          enlargeCenterPage: true,
                                          enlargeFactor: 0.3,
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF23232A),
                                          borderRadius:
                                              BorderRadius.circular(24),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: Image.network(
                                                'https://cdn-images.dzcdn.net/images/artist/d868d87e47d0597e6ba36d49eadec848/120x120-000000-80-0-0.jpg',
                                                height: 48,
                                                width: 48,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            const Expanded(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Circles',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Post Malone',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.play_circle_fill,
                                                  color: Colors.pink,
                                                  size: 36),
                                              onPressed: () {},
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
