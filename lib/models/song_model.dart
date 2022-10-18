class Song {
  final String title;
  final String description;
  final String url;
  final String coverUrl;

  Song(
      {required this.title,
      required this.description,
      required this.url,
      required this.coverUrl});

  static List<Song> songs = [
    Song(
        title: "Atomic Habits",
        description: "Chapter 1",
        url: "https://ipaudio.club/wp-content/uploads/GOLN/Atomic%20Habits/01.mp3",
        coverUrl: "assets/images/OutOfTheBlack.jpg"),
    Song(
        title: "Atomic Habits",
        description: "Chapter 2",
        url: "https://ipaudio.club/wp-content/uploads/GOLN/Atomic%20Habits/02.mp3",
        coverUrl: "assets/images/OutOfTheBlack.jpg"),
    Song(
        title: "Atomic Habits",
        description: "Chapter 3",
        url: "https://ipaudio.club/wp-content/uploads/GOLN/Atomic%20Habits/03.mp3",
        coverUrl: "assets/images/OutOfTheBlack.jpg"),
    Song(
        title: "Atomic Habits",
        description: "Chapter 4",
        url: "https://ipaudio.club/wp-content/uploads/GOLN/Atomic%20Habits/04.mp3",
        coverUrl: "assets/images/OutOfTheBlack.jpg"),
    Song(
        title: "Atomic Habits",
        description: "Chapter 5",
        url: "https://ipaudio.club/wp-content/uploads/GOLN/Atomic%20Habits/05.mp3",
        coverUrl: "assets/images/OutOfTheBlack.jpg"),
    Song(
        title: "Atomic Habits",
        description: "Chapter 6",
        url: "https://ipaudio.club/wp-content/uploads/GOLN/Atomic%20Habits/06.mp3",
        coverUrl: "assets/images/OutOfTheBlack.jpg"),

  ];
}
