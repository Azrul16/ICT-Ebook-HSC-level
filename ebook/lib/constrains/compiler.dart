import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:highlight/languages/xml.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';

String? detectHtmlErrors(String htmlContent) {
  if (htmlContent.trim().isEmpty) {
    return "এইচটিএমএল কনটেন্ট খালি।";
  }

  if (!htmlContent.contains(RegExp(r'<html[^>]*>', caseSensitive: false))) {
    return "<html> ট্যাগ অনুপস্থিত।";
  }
  if (!htmlContent.contains(RegExp(r'<body[^>]*>', caseSensitive: false))) {
    return "<body> ট্যাগ অনুপস্থিত।";
  }

  final selfClosingTags = <String>{
    'area',
    'base',
    'br',
    'col',
    'embed',
    'hr',
    'img',
    'input',
    'link',
    'meta',
    'source',
    'track',
    'wbr',
  };

  final openTagRegex = RegExp(r'<([a-zA-Z][a-zA-Z0-9]*)[^>/]*?>');
  final closeTagRegex = RegExp(r'</([a-zA-Z][a-zA-Z0-9]*)>');

  final openTags = <String>[];
  final closeTags = <String>[];

  for (final match in openTagRegex.allMatches(htmlContent)) {
    final tag = match.group(1)!.toLowerCase();
    if (!selfClosingTags.contains(tag)) {
      openTags.add(tag);
    }
  }

  for (final match in closeTagRegex.allMatches(htmlContent)) {
    closeTags.add(match.group(1)!.toLowerCase());
  }

  final tagCounts = <String, int>{};
  for (var tag in openTags) {
    tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
  }
  for (var tag in closeTags) {
    tagCounts[tag] = (tagCounts[tag] ?? 0) - 1;
  }

  for (var entry in tagCounts.entries) {
    if (entry.value != 0) {
      return "ট্যাগ <${entry.key}> অসম্পূর্ণ। খোলা এবং বন্ধ ট্যাগের সংখ্যা মেলে না।";
    }
  }

  // final cleaned = htmlContent.replaceAll(RegExp(r'<[^>]+>'), '').trim();
  // if (cleaned.isNotEmpty && !cleaned.contains(RegExp(r'[<>]'))) {
  //   return "অপরিচিত টেক্সট পাওয়া গেছে: \"$cleaned\"।";
  // }

  return null;
}

class HtmlCompilerTest extends StatefulWidget {
  const HtmlCompilerTest({super.key});

  @override
  State<HtmlCompilerTest> createState() => _HtmlCompilerState();
}

class _HtmlCompilerState extends State<HtmlCompilerTest> {
  final CodeController _codeController = CodeController(
    text: "",
    language: xml,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Card(
        margin: const EdgeInsets.all(8.0),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  const Text(
                    "নিজে চেষ্টা করুন",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.play_circle, color: Colors.green),
                    iconSize: 32.0,
                    onPressed: () {
                      final error = detectHtmlErrors(_codeController.text);

                      if (error != null) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('ত্রুটি পাওয়া গেছে'),
                            content: Text(error),
                            actions: [
                              TextButton(
                                child: const Text('ঠিক আছে'),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HtmlPreview(
                              htmlContent: _codeController.text,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              Expanded(
                child: CodeField(
                  controller: _codeController,
                  textStyle: const TextStyle(fontFamily: 'SourceCodePro'),
                  expands: true,
                  minLines: null,
                  maxLines: null,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HtmlPreview extends StatefulWidget {
  final String htmlContent;

  const HtmlPreview({super.key, required this.htmlContent});

  @override
  _HtmlPreviewState createState() => _HtmlPreviewState();
}

class _HtmlPreviewState extends State<HtmlPreview> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String _currentUrl = '';
  List<TabInfo> _tabs = [];

  @override
  void initState() {
    super.initState();
    _addNewTab(widget.htmlContent);
  }

  String _getAdjustedHtmlContent(String htmlContent) {
    final document = html_parser.parse(htmlContent);
    return '''
      <!DOCTYPE html>
      <html>
        <head>
          <style>
            body {
              font-size: 60px;
              font-family: Arial, sans-serif;
              margin: 0;
              padding: 0;
            }
          </style>
        </head>
        <body>
          ${document.body?.innerHtml ?? ''}
        </body>
      </html>
    ''';
  }

  void _addNewTab(String htmlContent) {
    final document = html_parser.parse(htmlContent);
    final title = document.getElementsByTagName('title').isNotEmpty
        ? document.getElementsByTagName('title')[0].text
        : "New Tab";

    final newTab = TabInfo(
      title: title,
      url: Uri.dataFromString(
        _getAdjustedHtmlContent(htmlContent),
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8'),
      ).toString(),
    );

    setState(() {
      _tabs.add(newTab);
    });
    _initializeController(newTab);
  }

  void _initializeController(TabInfo tab) {
    _controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (_) {
          setState(() {
            _isLoading = true;
          });
        },
        onPageFinished: (url) {
          setState(() {
            _isLoading = false;
            tab.url = url;
          });
        },
      ))
      ..loadRequest(Uri.parse(tab.url));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: TextEditingController(text: _currentUrl),
                  onSubmitted: (url) {
                    _controller.loadRequest(Uri.parse(url));
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter URL",
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _addNewTab(widget.htmlContent),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  _controller.reload();
                },
              ),
            ],
          ),
          bottom: TabBar(
            isScrollable: true,
            tabs: _tabs.map((tab) => Tab(text: tab.title)).toList(),
            onTap: (index) {
              setState(() {
                _initializeController(_tabs[index]);
              });
            },
          ),
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () async {
                  if (await _controller.canGoBack()) {
                    _controller.goBack();
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () async {
                  if (await _controller.canGoForward()) {
                    _controller.goForward();
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {
                  _controller.loadRequest(Uri.dataFromString(
                    _getAdjustedHtmlContent(widget.htmlContent),
                    mimeType: 'text/html',
                    encoding: Encoding.getByName('utf-8'),
                  ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TabInfo {
  String title;
  String url;
  TabInfo({required this.title, required this.url});
}
