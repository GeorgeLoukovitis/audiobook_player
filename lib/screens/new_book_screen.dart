import 'package:audiobook_player/models/book_model.dart';
import 'package:audiobook_player/services/file_handler.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class NewAudiobookScreen extends StatelessWidget {
  const NewAudiobookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 214, 24, 24),
      // body: NewAudiobookForm(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Colors.purple.shade200,
              Colors.purple.shade300,
              Colors.purple.shade800
            ])),
        child: const NewAudiobookForm(),
      ),
    );
  }
}

// Create a Form widget.
class NewAudiobookForm extends StatefulWidget {
  const NewAudiobookForm({super.key});

  @override
  NewAudiobookFormState createState() {
    return NewAudiobookFormState();
  }
}

class NewAudiobookFormState extends State<NewAudiobookForm> {
  final _formKey = GlobalKey<FormState>();
  List<String> trackURLs = [];

  TextEditingController titleController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController coverController = TextEditingController();
  TextEditingController newTrackController = TextEditingController();

  @override
  void dispose() {
    newTrackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "New Audiobook",
              style: Theme.of(context)
                  .textTheme
                  .headline3!
                  .copyWith(color: Colors.white),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple.shade800)),
                labelText: "Title",
                labelStyle: TextStyle(color: Colors.purple.shade800),
                hintText: 'Enter a audiobook title',
              ),
              controller: titleController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple.shade800)),
                labelText: "Author",
                labelStyle: TextStyle(color: Colors.purple.shade800),
                hintText: 'Enter the author\'s name',
              ),
              controller: authorController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple.shade800)),
                labelText: "Cover URL",
                labelStyle: TextStyle(color: Colors.purple.shade800),
                hintText: 'Enter the cover URL',
              ),
              controller: coverController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: TextFormField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.purple.shade800)),
                      labelText: "Track URL",
                      labelStyle: TextStyle(color: Colors.purple.shade800),
                      hintText: 'Add a new track',
                    ),
                    controller: newTrackController,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      final newURL = newTrackController.text;
                      if (newURL != null && newURL != "") {
                        setState(() {
                          trackURLs.add(newURL);
                          newTrackController.clear();
                        });
                      }
                    },
                    iconSize: 45,
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Tracks",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.white),
            ),
            Container(
              height: min(trackURLs.length * 55,
                  MediaQuery.of(context).size.height * 0.25),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                // physics: const NeverScrollableScrollPhysics(),
                itemCount: trackURLs.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: Text(trackURLs[index])),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              trackURLs.remove(trackURLs[index]);
                            });
                          },
                          icon: const Icon(Icons.remove))
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Audiobook audiobook = Audiobook(
                        title: titleController.text,
                        author: authorController.text,
                        trackURLs: trackURLs,
                        coverURL: coverController.text);
                    print(audiobook.trackURLs);
                    FileHandler fileHandler = FileHandler.instance;
                    await fileHandler.writeAudiobook(audiobook);
                  }
                },
                child: const Text('Submit'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  FileHandler fileHandler = FileHandler.instance;
                  await fileHandler.deleteAll();
                  List<Audiobook> audiobooks =
                      await fileHandler.readAudiobooks();
                  print(audiobooks);
                },
                child: const Text('Delete All'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
