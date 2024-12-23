import 'package:ebook/constrains/compiler.dart';
import 'package:flutter/material.dart';

class Lesson1 extends StatefulWidget {
  const Lesson1({super.key});

  @override
  State<Lesson1> createState() => _Lesson1State();
}

class _Lesson1State extends State<Lesson1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HTML Compiler"),
      ),
      body: Column(
        children: [
          HtmlCompiler(),
        ],
      ),
    );
  }
}
