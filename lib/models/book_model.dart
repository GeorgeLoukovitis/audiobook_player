import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:equatable/equatable.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

class Audiobook extends Equatable {
  final String title;
  final String author;
  final List<String> trackURLs;
  final String coverURL;
  List<Bookmark> bookmarks = [];
  bool downloaded = false;
  List<String> localTrackLocations = [];
  Bookmark lastPosition = const Bookmark(0, Duration.zero);

  Audiobook.zero()
      : title = "",
        author = "",
        trackURLs = [],
        coverURL = "";

  Audiobook(
      {required this.title,
      required this.author,
      required this.trackURLs,
      required this.coverURL});

  void addBookmark(Bookmark bookmark) {
    bookmarks.add(bookmark);
  }

  void removeBookmart(Bookmark bookmark) {
    bookmarks.remove(bookmark);
  }

  void setPosition(int track, Duration place) {
    lastPosition = Bookmark(track, place);
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    if (true) {
      print(
          'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    }
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
  }

  Future<void> download() async {
    if (!downloaded) {
      final String downloadPath =
          "${(await getApplicationDocumentsDirectory()).path}/$title";

      Directory directory =
          await Directory(downloadPath).create(recursive: true);

      await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
      FlutterDownloader.registerCallback(downloadCallback);

      for (int i = 0; i < trackURLs.length; i++) {
        final taskId = await FlutterDownloader.enqueue(
            url: trackURLs[i],
            headers: {},
            savedDir: downloadPath,
            saveInPublicStorage: true);
        await Future.delayed(const Duration(seconds: 5));
      }

      List<FileSystemEntity> files = directory.listSync();
      files.sort(((a, b) => (a.path.compareTo(b.path))));

      // print(files);
      localTrackLocations = files.map((e) => e.path).toList();
      downloaded = true;
      print(localTrackLocations);
    }
  }

  Audiobook.fromJson(Map<String, dynamic> map)
      : title = map["title"] as String,
        author = map["author"] as String,
        coverURL = map["coverURL"] as String,
        trackURLs = List<String>.from(jsonDecode(map["trackURLs"])),
        bookmarks = List<dynamic>.from(
            jsonDecode(map["bookmarks"]??"[]")
        ).map((e) => Bookmark.fromJson(e)).toList(),
        downloaded = map["downloaded"] as bool,
        localTrackLocations =
            List<String>.from(jsonDecode(map["localTrackLocations"])),
        lastPosition = Bookmark.fromJson(map["lastPosition"]);

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "author": author,
      "coverURL": coverURL,
      "trackURLs": jsonEncode(trackURLs),
      "bookmarks": jsonEncode(bookmarks),
      "downloaded": downloaded,
      "localTrackLocations": jsonEncode(localTrackLocations),
      "lastPosition": lastPosition.toJson()
    };
  }

  List<Object> get props => [title, author, coverURL, trackURLs];
}

class Bookmark extends Equatable {
  final int track;
  final Duration place;

  const Bookmark(this.track, this.place);

  Bookmark.fromJson(Map<String, dynamic> map)
      : track = map["track"],
        place = Duration(seconds: map["place"]);

  Map<String, dynamic> toJson() {
    return {"track": track, "place": place.inSeconds};
  }

  List<Object> get props => [track, place];
}
