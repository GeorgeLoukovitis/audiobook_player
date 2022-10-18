import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'screens/screens.dart';
import 'screens/screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "AudioBook Player",
      theme: ThemeData(
          textTheme: Theme.of(context)
              .textTheme
              .apply(bodyColor: Colors.white, displayColor: Colors.white)),
      home: const HomeScreen(),
      getPages: [
        GetPage(name: "/", page: () => const HomeScreen()),
        GetPage(name: "/song", page: () => const SongScreen()),
        GetPage(name: "/playlist", page: () => const PlaylistScreen()),
        GetPage(name: "/newBook", page: () => const NewAudiobookScreen()),
        GetPage(name: "/bookmarks", page: () => const BookmarksScreen()),
      ],
    );
  }
}
