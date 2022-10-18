import 'dart:convert';
import 'dart:io';

import 'package:audiobook_player/models/book_model.dart';
import 'package:audiobook_player/models/song_model.dart';
import 'package:audiobook_player/services/file_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart' as rxdart;
import 'package:uri_to_file/uri_to_file.dart' as utf;
import '../widgets/widgets.dart';

class SongScreen extends StatefulWidget {
  const SongScreen({super.key});

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
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
    audiobook.setPosition(
        audioPlayer.sequenceState!.currentIndex, audioPlayer.position);
    FileHandler fileHandler = FileHandler.instance;
    print(await fileHandler.readAudiobooks());
    audioPlayer.dispose();
  }

  Stream<SeekBarData> get _seekBarDataStream =>
      rxdart.Rx.combineLatest2<Duration, Duration?, SeekBarData>(
          audioPlayer.positionStream,
          audioPlayer.durationStream,
          (Duration position, Duration? duration) =>
              SeekBarData(position, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(fit: StackFit.expand, children: [
        Image.network(
          audiobook.coverURL,
          fit: BoxFit.cover,
        ),
        const _BackgroundFilter(),
        _MusicPlayer(
            audiobook: audiobook,
            seekBarDataStream: _seekBarDataStream,
            audioPlayer: audioPlayer),
      ]),
    );
  }
}

class _MusicPlayer extends StatelessWidget {
  const _MusicPlayer({
    Key? key,
    required this.audiobook,
    required Stream<SeekBarData> seekBarDataStream,
    required this.audioPlayer,
  })  : _seekBarDataStream = seekBarDataStream,
        super(key: key);

  final Stream<SeekBarData> _seekBarDataStream;
  final AudioPlayer audioPlayer;
  final Audiobook audiobook;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            audiobook.title,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            audiobook.author,
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.white),
          ),
          const SizedBox(
            height: 30,
          ),
          StreamBuilder<SeekBarData>(
            stream: _seekBarDataStream,
            builder: (context, snapshot) {
              final positionData = snapshot.data;
              return SeekBar(
                position: positionData?.position ?? Duration.zero,
                duration: positionData?.duration ?? Duration.zero,
                onChangeEnd: audioPlayer.seek,
              );
            },
          ),
          PlayerButtons(audioPlayer: audioPlayer),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: () => Get.toNamed("/bookmarks", arguments: audiobook),
                  iconSize: 30,
                  icon: const Icon(
                    Icons.list,
                    color: Colors.white,
                  )),
              IconButton(
                  onPressed: () {
                    final Bookmark bookmark = Bookmark(
                        audioPlayer.sequenceState!.currentIndex,
                        audioPlayer.position);
                    // final List<Bookmark> list = [bookmark, bookmark];
                    // print(list);
                    // final String json = jsonEncode(list);
                    // print(json);
                    // final List<dynamic> list2 = jsonDecode(json);
                    // final List<Bookmark> listBookmark =
                    //     list2.map((e) => Bookmark.fromJson(e)).toList();
                    // print(list2);
                    // print(listBookmark);

                    audiobook.addBookmark(bookmark);
                    FileHandler fileHandler = FileHandler.instance;
                    fileHandler.updateAudiobook(
                        title: audiobook.title, updatedAudiobook: audiobook);
                    print(audiobook.bookmarks);
                  },
                  iconSize: 30,
                  icon: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                  )),
              IconButton(
                  onPressed: () async {
                    if (!audiobook.downloaded) {
                      await audiobook.download();
                      FileHandler fileHandler = FileHandler.instance;
                      fileHandler.updateAudiobook(
                          title: audiobook.title, updatedAudiobook: audiobook);
                    }
                  },
                  iconSize: 30,
                  icon: Icon(
                    Icons.download,
                    color: audiobook.downloaded ? Colors.grey : Colors.white,
                  )),
            ],
          )
        ],
      ),
    );
  }
}

class _BackgroundFilter extends StatelessWidget {
  const _BackgroundFilter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withOpacity(1.0),
              Colors.white.withOpacity(0.7),
              Colors.white.withOpacity(0.0),
            ],
            stops: const [
              0.0,
              0.4,
              0.6
            ]).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Colors.deepPurple.shade200,
              Colors.deepPurple.shade800
            ])),
      ),
    );
  }
}
