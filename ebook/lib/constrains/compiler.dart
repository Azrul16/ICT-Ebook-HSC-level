import 'dart:convert';
import 'package:ebook/constrains/error_detection.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:highlight/languages/xml.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';

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
          padding: const EdgeInsets.only(
              left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
          child: Column(
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "নিজে চেষ্টা করুন",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: const Icon(Icons.play_circle, color: Colors.green),
                    iconSize: 32.0, // Increase the size of the icon
                    onPressed: () {
                      final error = detectHtmlErrors(_codeController.text);

                      if (error != null) {
                        // Show error dialog
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
                        // Navigate to preview
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                HtmlPreview(htmlContent: _codeController.text),
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
  // ignore: library_private_types_in_public_api
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

    // Initialize the first tab
    _addNewTab(widget.htmlContent);
  }

  String _getAdjustedHtmlContent(String htmlContent) {
    final document = html_parser.parse(htmlContent);

    // Default to "New Tab" if <title> is not present
    final title = document.getElementsByTagName('title').isNotEmpty
        ? document.getElementsByTagName('title')[0].text
        : "New Tab";

    return '''
      <!DOCTYPE html>
      <html>
        <head>
          <style>
            body {
              font-size: 20px; /* Larger font size */
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
            tabs: _tabs
                .map((tab) => Tab(
                      text: tab.title,
                    ))
                .toList(),
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
