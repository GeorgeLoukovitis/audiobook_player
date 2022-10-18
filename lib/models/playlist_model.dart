import 'song_model.dart';

class Playlist {
  final String title;
  final List<Song> songs;
  final String coverUrl;

  Playlist({required this.title, required this.songs, required this.coverUrl});

  static List<Playlist> playlists = [
    Playlist(
        title: "Playlist1",
        songs: Song.songs,
        coverUrl:
            "https://images.unsplash.com/photo-1665412019489-1928d5afa5cc?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1365&q=80"),
    Playlist(
        title: "Playlist2",
        songs: Song.songs,
        coverUrl:
            "https://images.unsplash.com/photo-1665412019489-1928d5afa5cc?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1365&q=80"),
    Playlist(
        title: "Playlist3",
        songs: Song.songs,
        coverUrl:
            "https://images.unsplash.com/photo-1665412019489-1928d5afa5cc?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1365&q=80"),
  ];
}
