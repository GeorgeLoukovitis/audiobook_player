import 'package:audiobook_player/models/book_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/song_model.dart';

class SongCard extends StatelessWidget {
  const SongCard({
    Key? key,
    required this.audiobook,
  }) : super(key: key);

  final Audiobook audiobook;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed("/song", arguments: audiobook);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10.0),
        child: Stack(alignment: Alignment.bottomCenter, children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.45,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                image: DecorationImage(
                    image: NetworkImage(audiobook.coverURL),
                    fit: BoxFit.cover)),
          ),
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width * 0.37,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white.withOpacity(0.8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        (audiobook.title.length > 13)
                            ? "${audiobook.title.substring(0, 13)}..."
                            : audiobook.title,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold)),
                    Text(
                        (audiobook.author.length > 13)
                            ? "${audiobook.author.substring(0, 13)}..."
                            : audiobook.author,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                  ],
                ),
                const Icon(
                  Icons.play_circle,
                  color: Colors.deepPurple,
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
