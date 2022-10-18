import 'dart:convert';
import 'dart:io';

import 'package:audiobook_player/models/book_model.dart';
import 'package:path_provider/path_provider.dart';

class FileHandler {
  FileHandler._privateConstructor();
  static final FileHandler instance = FileHandler._privateConstructor();
  static File? _file;

  static final _fileName = 'book_file.txt';

  // Get the data file
  Future<File> get file async {
    if (_file != null) return _file!;

    _file = await _initFile();

    // ===================
    final content = await _file!.readAsString();
    final List<dynamic> jsonData = jsonDecode(content);
    final List<Audiobook> audiobooks = jsonData
        .map((e) => Audiobook.fromJson(e as Map<String, dynamic>))
        .toList();
    _audiobookSet = audiobooks.toSet();
    // ==================

    return _file!;
  }

  // Inititalize file
  Future<File> _initFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    return File('$path/$_fileName');
  }

  static Set<Audiobook> _audiobookSet = {};

  Future<void> writeAudiobook(Audiobook audiobook) async {
    final File fl = await file;
    _audiobookSet.add(audiobook);

    final audiobookListMap = _audiobookSet.map((e) => e.toJson()).toList();
    await fl.writeAsString(jsonEncode(audiobookListMap));
  }

  Future<List<Audiobook>> readAudiobooks() async {
    final File fl = await file;
    final content = await fl.readAsString();

    final List<dynamic> jsonData = jsonDecode(content);
    final List<Audiobook> audiobooks = jsonData
        .map((e) => Audiobook.fromJson(e as Map<String, dynamic>))
        .toList();

    return audiobooks;
  }

  Future<void> deleteAudiobook(Audiobook audiobook) async {
    final File fl = await file;
    _audiobookSet.removeWhere((e) => e == audiobook);

    final audiobookListMap = _audiobookSet.map((e) => e.toJson()).toList();
    await fl.writeAsString(jsonEncode(audiobookListMap));
  }

  Future<void> updateAudiobook(
      {required String title, required Audiobook updatedAudiobook}) async {
    _audiobookSet.removeWhere((element) => element.title == title);
    writeAudiobook(updatedAudiobook);
  }

  Future<void> deleteAll() async {
    final File fl = await file;
    _audiobookSet.clear();

    final audiobookListMap = _audiobookSet.map((e) => e.toJson()).toList();
    await fl.writeAsString(jsonEncode(audiobookListMap));
  }

  void test() {}
}
