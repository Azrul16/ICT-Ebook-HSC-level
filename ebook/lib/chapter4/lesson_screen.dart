import 'package:ebook/constrains/compiler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlighter/flutter_highlighter.dart';
import 'package:flutter_highlighter/themes/atom-one-dark.dart';
import 'data/lessons.dart';
import 'html_compiler.dart';

class LessonScreen extends StatefulWidget {
  final Lesson lesson;

  const LessonScreen({super.key, required this.lesson});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  final int lessonIndex =
      lessons.indexOf(lessons.firstWhere((l) => l.title == lessons[0].title));
  @override
  Widget build(BuildContext context) {
    int lessonIndex = lessons.indexOf(widget.lesson); // Correctly find index

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.lesson.title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF87CEEB), Color(0xFFADD8E6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF5FAFF), Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                widget.lesson.content,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.black87,
                  fontFamily: 'NotoSansBengali',
                ),
              ),
            ),
            if (widget.lesson.code.isNotEmpty) ...[
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'কোড উদাহরণ:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF87CEEB),
                    ),
                  ),
                  Tooltip(
                    message: 'কোড কপি করুন',
                    child: IconButton(
                      icon: const Icon(Icons.copy, color: Color(0xFF87CEEB)),
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: widget.lesson.code));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('কোড কপি করা হয়েছে!'),
                            backgroundColor: Color(0xFF87CEEB),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D2D2D),
                  borderRadius: BorderRadius.circular(15.0),
                  border:
                      Border.all(color: const Color(0xFF87CEEB), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: HighlightView(
                  widget.lesson.code,
                  language: 'html',
                  theme: atomOneDarkTheme,
                  padding: const EdgeInsets.all(12.0),
                  textStyle: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF87CEEB).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Text(
                  'টিপ: কোডটি চালানোর জন্য একটি HTML এডিটর ব্যবহার করুন এবং ফলাফল দেখুন!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF87CEEB),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              HtmlCompilerTest(),
            ],

            const SizedBox(height: 20),
            // Navigation Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: lessonIndex > 0
                      ? () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LessonScreen(
                                  lesson: lessons[lessonIndex - 1]),
                            ),
                          );
                        }
                      : null,
                  icon: const Icon(Icons.arrow_left, color: Colors.white),
                  label: const Text(
                    'পূর্ববর্তী',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'NotoSansBengali',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF87CEEB),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: lessonIndex < lessons.length - 1
                      ? () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LessonScreen(
                                  lesson: lessons[lessonIndex + 1]),
                            ),
                          );
                        }
                      : null,
                  icon: const Icon(Icons.arrow_right, color: Colors.white),
                  label: const Text(
                    'পরবর্তী',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'NotoSansBengali',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF87CEEB),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       const SnackBar(
      //         content: Text('বুকমার্ক যোগ করা হয়েছে!'),
      //         backgroundColor: Color(0xFF87CEEB),
      //       ),
      //     );
      //   },
      //   backgroundColor: const Color(0xFF87CEEB),
      //   child: const Icon(Icons.bookmark_border, color: Colors.white),
      //   tooltip: 'বুকমার্ক করুন',
      // ),
    );
  }
}
