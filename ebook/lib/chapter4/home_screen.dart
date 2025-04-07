import 'package:flutter/material.dart';
import 'lesson_screen.dart';
import 'data/lessons.dart';

class HomeScreen1 extends StatelessWidget {
  const HomeScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coding eBook',
      theme: ThemeData(
        primaryColor: const Color(0xFF87CEEB), // Light Sky Blue
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyLarge:
              TextStyle(color: Colors.black87, fontFamily: 'NotoSansBengali'),
          bodyMedium:
              TextStyle(color: Colors.black87, fontFamily: 'NotoSansBengali'),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF87CEEB),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('কোডিং ইবুক'),
          centerTitle: true,
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: lessons.length,
          itemBuilder: (context, index) {
            return Card(
              color: const Color(0xFFF5FAFF), // Very light sky blue shade
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(
                  lessons[index].title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF87CEEB),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          LessonScreen(lesson: lessons[index]),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
