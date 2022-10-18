import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayerButtons extends StatelessWidget {
  const PlayerButtons({
    Key? key,
    required this.audioPlayer,
  }) : super(key: key);

  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () {
              Duration newPos =
                  (audioPlayer.position >= const Duration(seconds: 30))
                      ? audioPlayer.position - const Duration(seconds: 30)
                      : Duration.zero;
              audioPlayer.seek(newPos);
            },
            iconSize: 45,
            icon: const Icon(
              Icons.replay_30_outlined,
              color: Colors.white,
            )),
        StreamBuilder<SequenceState?>(
          stream: audioPlayer.sequenceStateStream,
          builder: (context, snapshot) {
            return IconButton(
                onPressed:
                    audioPlayer.hasPrevious ? audioPlayer.seekToPrevious : null,
                iconSize: 45.0,
                icon: const Icon(
                  Icons.skip_previous,
                  color: Colors.white,
                ));
          },
        ),
        StreamBuilder<PlayerState>(
          stream: audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final playerState = snapshot.data;
              final processingState = playerState!.processingState;

              if (processingState == ProcessingState.loading ||
                  processingState == ProcessingState.buffering) {
                return Container(
                  width: 64.0,
                  height: 64.0,
                  margin: const EdgeInsets.all(10.0),
                  child: const CircularProgressIndicator(),
                );
              } else if (!audioPlayer.playing) {
                return IconButton(
                    onPressed: audioPlayer.play,
                    iconSize: 75.0,
                    icon: const Icon(
                      Icons.play_circle,
                      color: Colors.white,
                    ));
              } else if (processingState != ProcessingState.completed) {
                return IconButton(
                  onPressed: audioPlayer.pause,
                  iconSize: 75.0,
                  icon: const Icon(
                    Icons.pause_circle,
                    color: Colors.white,
                  ),
                );
              } else {
                return IconButton(
                  onPressed: () => audioPlayer.seek(Duration.zero,
                      index: audioPlayer.effectiveIndices!.first),
                  iconSize: 75.0,
                  icon: const Icon(
                    Icons.replay_circle_filled_outlined,
                    color: Colors.white,
                  ),
                );
              }
            } else {
              return Container(
                width: 64.0,
                height: 64.0,
                margin: const EdgeInsets.all(10.0),
                child: const CircularProgressIndicator(),
              );
            }
          },
        ),
        StreamBuilder<SequenceState?>(
          stream: audioPlayer.sequenceStateStream,
          builder: (context, snapshot) {
            return IconButton(
                onPressed: audioPlayer.hasNext ? audioPlayer.seekToNext : null,
                iconSize: 45.0,
                icon: const Icon(
                  Icons.skip_next,
                  color: Colors.white,
                ));
          },
        ),
        IconButton(
            onPressed: () {
              if (audioPlayer.duration != null) {
                Duration newPos = (audioPlayer.position <=
                        const Duration(seconds: 30) + audioPlayer.duration!)
                    ? audioPlayer.position + const Duration(seconds: 30)
                    : audioPlayer.duration!;
                audioPlayer.seek(newPos);
              }
            },
            iconSize: 45,
            icon: const Icon(
              Icons.forward_30_outlined,
              color: Colors.white,
            )),
      ],
    );
  }
}
