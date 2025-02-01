import 'package:ebook/constrains/code_field.dart';
import 'package:ebook/constrains/compiler.dart';
import 'package:flutter/material.dart';

class Lesson2 extends StatefulWidget {
  const Lesson2({super.key});

  @override
  State<Lesson2> createState() => _Lesson1State();
}

class _Lesson1State extends State<Lesson2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          child: const Text(
            "HTML এর এন্টি",
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "একটি এইচটিএমএল ডকুমেন্টে এলিমেন্টগুলো একটির পরে একটি থাকতে পারবে। আবার, একটি এলিমেন্টের ভেতর এক বা একাধিক এলিনেন্ট থাকতে পারে। তবে একটি এলিমেন্ট জন্য একটি এলিমেন্টকে সমাপতিত (overlap) করতে পারবে না। এলিমেন্টগুলোকে অসংখ্য বিভিন্ন আকারের কৌটার সঙ্গে তুলনা করা যেতে পারে। একটি বড় কৌটার ভেতরে ছোট ছোট কয়েকটি কৌটা থাকতে পারে। একটির পাশে অন্যটি বা একটির উপর অন্য কৌটা থাকতে পারে। কিন্তু কখনোই একটি কৌটা অন্য দুই বা ততোধিক কৌটার ভেতরে থাকতে পারবে না। এখানে কৌটার মুখ ও ভলাকে ওপেনিং ও ক্লোজিং ট্যাগ হিসেবে চিন্তা করা যেতে পারে। ",
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: CodeFieldWithToggle(
                text:
                    '<p> <em> Abracadabra</p> </em> ভুল \n<p> <em> Abracadabra </em> </p> সঠিক .',
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'হেডিং (Heading) কাগজ পড়ার সময় বিভিন্ন রকম শিরোনাম বা হেডিং দেখতে পাওয়া যায়। প্রধান শিরোনাম থাকে অনেক বড় অক্ষরে, তারপর আরো বিভিন্ন আকারে বিভিন্ন শিরোনাম থাকে। সেরকম এইচটিএমএল পেইজেও বিভিন্ন আকারের হেডিং দেওয়া যায়। এইচটিএমএলে ছয়টি হেডিং এলিমেন্ট রয়েছে। এগুলো, যথাক্রমে h1,h2,h3,h4,h5h6 দিয়ে প্রকাশ করা হয়। এর মধ্যে h1-এর আকার সবচেয়ে বড়, h এর আকার সবচেয়ে ছোট। কোনটির আকার কেমন তা জানার জন্য একটি কোড দেখানো হলো। ',
              ),
            ),
            CodeFieldWithToggle(
                text:
                    "<!DOCTYPE html> \n<html> \n<head> \n<title>HTML Heading</title> \n</head> \n<body> \n<h1>This is heading 1</h1> \n<h2>This is heading 2</h2> \n<h3>This is heading 3</h3> \n<h4>This is heading 4</h4> \n<h5>This is heading 5</h5> \n<h6>This is heading 6</h6> \n</body> \n</html> "),
            HtmlCompiler(),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Text("PREV"),
                  ),
                  Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const Lesson2()));
                      // Define the action to perform when the button is pressed
                      print("Next button pressed");
                    },
                    child: Text(
                      "NEXT",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
