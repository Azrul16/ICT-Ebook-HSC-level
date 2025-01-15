import 'package:ebook/constrains/compiler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';

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
        title: SizedBox(
          child: const Text(
            "এইচটিএমএল-এর মৌলিক বিষয়সমূহ ",
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'HTML উপাদান (HTML Element)',
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "একটি বইয়ে সাধারণত কী কী অংশ থাকে সেটি বিবেচনা করা যাক। বইয়ের একাধিক খণ্ড থাকতে পারে, একটি খণ্ডে একাধিক অধ্যায় থাকে। প্রতিটি অধ্যায়ে আবার শিরোনাম বা হেডিং, সাবহেডিং, অনুচ্ছেদ বা  প্যারাগ্রাফ থাকতে পারে। এছাড়াও বইতে বিভিন্ন ছবি, ছবির ক্যাপশন, সারণি বা টেবিল ইত্যাদি অংশ থাকতে পারে। তেমনি একটি HTML পেইজেও বিভিন্ন অংশ বা উপাদান থাকে। এ উপাদানগুলোকে বলা হয় HTML এলিমেন্ট (HTM Elements) ।  HTML-এর এলিমেন্ট লেখার জন্য ব্যবহার করা হয় ট্যাগ। ট্যাগকে অনেকটা ব্র্যাকেট বা বন্ধনীর সঙ্গে তুলনা করা যেতে পারে। সাধারণত এলিমেন্টের শুরু বোঝাতে একটি ওপেনিং ট্যাগ এবং শেষ বোঝাতে একটি ক্লোজিং ট্যাগ ব্যবহার করা হয়। ওপেনিং ট্যাগ, দুই ট্যাগের মধ্যবর্তী কনটেন্ট ও ক্লোজিং ট্যাগ মিলে যা হয় তা-ই একটি এলিমেন্ট। তবে কিছু এলিমেন্ট আছে যাদের মধ্যে কোনো কনটেন্ট থাকে না, তাই এদের ক্লোজিং ট্যাগও থাকে না। এদেরকে বলা হয় এম্পটি (empty) এলিমেন্ট। ট্যাগ গঠিত হয় এলিমেন্টের নাম বা নামের অংশ দিয়ে। ওপেনিং ও ক্লোজিং ট্যাগের গঠন হয় এরকম, <element_name> ও < / element_name> | দুটি অ্যাঙ্গেল ব্র্যাকেটের ভেতরে এলিমেন্টের নাম লিখলে হয় ওপেনিং ট্যাগ, আর ক্লোজিং ট্যাগ হয় এ রকম, </...>। অর্থাৎ, এলিমেন্টের নামের আগে একটি অতিরিক্ত ফরওয়ার্ড স্ল্যাশ চিহ্ন (Forward Slash – 1) দেওয়া হয়। ওপেনিং এবং ক্লোজিং ট্যাগের ভেতরের লেখা এলিমেন্টের নাম একই হতে হবে।",
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'ট্যাগ গঠিত হয় এলিমেন্টের নাম বা নামের অংশ দিয়ে। ওপেনিং ও ক্লোজিং ট্যাগের গঠন হয় এরকম, <element_name> ও < / element_name> | দুটি অ্যাঙ্গেল ব্র্যাকেটের ভেতরে এলিমেন্টের নাম লিখলে হয় ওপেনিং ট্যাগ, আর ক্লোজিং ট্যাগ হয় এ রকম, </...>। অর্থাৎ, এলিমেন্টের নামের আগে একটি অতিরিক্ত ফরওয়ার্ড স্ল্যাশ চিহ্ন (Forward Slash – 1) দেওয়া হয়। ওপেনিং এবং ক্লোজিং ট্যাগের ভেতরের লেখা এলিমেন্টের নাম একই হতে হবে। \nনিচে একটি HTML কোড দেখানো হলো। ',
              ),
            ),
            CodeField(
              controller: CodeController(
                  text:
                      "<!DOCTYPE html> \n<html> \m<body> \nHello World! \n</body>\n</html>"),
            ),
            HtmlCompiler(),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
