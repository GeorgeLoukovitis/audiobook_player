import 'dart:io';

import 'package:audiobook_player/services/file_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../models/book_model.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  AudioPlayer audioPlayer = AudioPlayer();
  Audiobook audiobook = Get.arguments;

  @override
  void initState() {
    super.initState();
    if (audiobook.downloaded) {
      print("Downloaded");

      audioPlayer.setAudioSource(ConcatenatingAudioSource(
          children: audiobook.localTrackLocations.map((url) {
        File file = File(url);
        Uri uri = Uri.parse(file.path);
        return ProgressiveAudioSource(uri);
      }).toList()));

      audioPlayer.seek(audiobook.lastPosition.place,
          index: audiobook.lastPosition.track);
    } else {
      print("Not Downloaded");
      audioPlayer.setAudioSource(ConcatenatingAudioSource(
          children: audiobook.trackURLs
              .map((url) => AudioSource.uri(Uri.parse(url)))
              .toList()));

      audioPlayer.seek(audiobook.lastPosition.place,
          index: audiobook.lastPosition.track);
    }
  }

  @override
  void dispose() async {
    super.dispose();
    audioPlayer.dispose();
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) {
      return "--:--";
    } else {
      String minutes = duration.inMinutes.toString().padLeft(2, "0");
      String seconds =
          duration.inSeconds.remainder(60).toString().padLeft(2, "0");
      return "$minutes:$seconds";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Colors.deepPurple.shade800.withOpacity(0.8),
            Colors.deepPurple.shade200.withOpacity(0.8)
          ])),
      child: Scaffold(
        appBar: AppBar(
          title: Text('${audiobook.title} - Bookmarks'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: audiobook.bookmarks.length,
            itemBuilder: (context, index) {
              return ListTile(
                  title: Text(
                    'Track ${audiobook.bookmarks[index].track} - Position ${_formatDuration(audiobook.bookmarks[index].place)}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Colors.white),
                  ),
                  trailing: Container(
                    width: 100.0,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                audiobook.bookmarks.removeAt(index);
                                FileHandler fileHandler = FileHandler.instance;
                                fileHandler.updateAudiobook(
                                    title: audiobook.title,
                                    updatedAudiobook: audiobook);
                              });
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            )),
                        StreamBuilder<PlayerState>(
                          stream: audioPlayer.playerStateStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final playerState = snapshot.data;
                              final processingState =
                                  playerState!.processingState;

                              if (processingState == ProcessingState.loading ||
                                  processingState ==
                                      ProcessingState.buffering) {
                                return Container(
                                  width: 32.0,
                                  height: 32.0,
                                  child: const CircularProgressIndicator(),
                                );
                              } else if (!audioPlayer.playing) {
                                return IconButton(
                                    icon: const Icon(
                                      Icons.play_arrow,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      final Bookmark bookmark =
                                          audiobook.bookmarks[index];
                                      final Duration pos = (bookmark.place >=
                                              const Duration(seconds: 30))
                                          ? bookmark.place -
                                              const Duration(seconds: 30)
                                          : Duration.zero;
                                      audioPlayer.seek(pos,
                                          index: bookmark.track);
                                      audioPlayer.play();
                                    });
                              } else if (processingState !=
                                  ProcessingState.completed) {
                                return IconButton(
                                  onPressed: audioPlayer.pause,
                                  icon: const Icon(
                                    Icons.pause,
                                    color: Colors.white,
                                  ),
                                );
                              } else {
                                return IconButton(
                                  onPressed: () => audioPlayer.seek(
                                      Duration.zero,
                                      index:
                                          audioPlayer.effectiveIndices!.first),
                                  iconSize: 75.0,
                                  icon: const Icon(
                                    Icons.replay_circle_filled_outlined,
                                    color: Colors.white,
                                  ),
                                );
                              }
                            } else {
                              return Container(
                                width: 32.0,
                                height: 32.0,
                                // margin: const EdgeInsets.all(10.0),
                                child: const CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ));
            },
          ),
        ),
      ),
    );
  }
}
