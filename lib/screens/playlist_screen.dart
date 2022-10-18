import 'package:audiobook_player/models/song_model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  AudioPlayer audioPlayer = AudioPlayer(playerId: "Player 1");

  @override
  void initState() {
    super.initState();
    // UrlSource source = UrlSource(Song.songs[0].url);

    // audioPlayer.setSource(source);
    audioPlayer.setSourceAsset("music/TheOtherSideOfParadise.mp3");
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // audioPlayer.play(UrlSource(Song.songs[0].url));
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade800,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: audioPlayer.resume,
                  iconSize: 64,
                  icon: const Icon(
                    Icons.play_circle_fill_outlined,
                    color: Colors.white,
                  )),
              IconButton(
                  onPressed: audioPlayer.pause,
                  iconSize: 64,
                  icon: const Icon(
                    Icons.pause_circle_outline,
                    color: Colors.white,
                  ))
            ],
          )
        ],
      ),
    );
  }
}
