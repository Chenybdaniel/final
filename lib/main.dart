import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:page_transition/page_transition.dart';

void main() {
  runApp(const MaterialApp(
    title: 'Notes',
    debugShowCheckedModeBanner: false,
    home: FirstRoute(),
  ));
}

class FirstRoute extends StatelessWidget {
  const FirstRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Notes'),
          onPressed: () {
            Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child:MyApp()));
          },
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Notes'),
        ),
        body: MyClass(storage: TextStorage()),
      ),
    );
  }
}
class MyClass extends StatefulWidget {
  const MyClass({Key? key, required this.storage}) : super(key: key);
  final TextStorage storage;

  @override
  _MyClassState createState() => _MyClassState();
}

class _MyClassState extends State<MyClass> {

  late TextEditingController myController;

  var _text = null;

  @override
  void initState(){
    super.initState();
    widget.storage.readText().then((var value) {
      setState(() {
        _text = value;
        myController = new TextEditingController(text:_text);
      });
    });
  }

  void _writeText() {
    widget.storage.writeText(myController.text);
    setState(() {
    });
    // Write the variable as a string to the file.
  }
  void dispose() {
    myController.dispose();
    super.dispose();
    _writeText();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            children: <Widget>[
              TextField(
                controller: myController,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 100),
                    border: InputBorder.none),
                maxLines: 15,
                minLines: 1,
              ),

            ],
          ),
        )
    );
  }
}

class TextStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/text.txt');
  }

  Future<String> readText() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return ' ';
    }
  }

  Future<File> writeText(String text) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$text');
  }
}