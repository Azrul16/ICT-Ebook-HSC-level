import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_highlighter/flutter_highlighter.dart';
import 'package:flutter_highlighter/themes/atom-one-dark.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:html/parser.dart' as html_parser;

class HtmlCompiler extends StatefulWidget {
  final String initialCode;
  final TextEditingController _textController;

  HtmlCompiler({super.key, this.initialCode = ""})
      : _textController = TextEditingController(text: initialCode);

  @override
  State<HtmlCompiler> createState() => _HtmlCompilerState();
}

class _HtmlCompilerState extends State<HtmlCompiler> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Card(
        margin: const EdgeInsets.all(8.0),
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: const Color(0xFFF5FAFF),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  const Text(
                    "নিজে চেষ্টা করুন",
                    style: TextStyle(
                      color: Color(0xFF87CEEB),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'NotoSansBengali',
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.play_circle, color: Colors.green),
                    iconSize: 32.0,
                    tooltip: 'কোড চালান',
                    onPressed: () {
                      if (widget._textController.text.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HtmlPreview(
                                htmlContent: widget._textController.text),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('কোড লিখুন প্রথমে!'),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.clear, color: Colors.redAccent),
                    iconSize: 32.0,
                    tooltip: 'কোড মুছুন',
                    onPressed: () {
                      widget._textController.clear();
                      setState(() {
                        widget._textController.text = '';
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('কোড মুছে ফেলা হয়েছে!'),
                          backgroundColor: Color(0xFF87CEEB),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D2D2D),
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: const Color(0xFF87CEEB), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: HighlightView(
                            widget._textController.text.isEmpty
                                ? '<!-- এখানে HTML কোড লিখুন -->'
                                : widget._textController.text,
                            language: 'html',
                            theme: atomOneDarkTheme,
                            textStyle: const TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: TextField(
                            controller: widget._textController,
                            style: const TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 14,
                              color: Colors.transparent,
                            ),

                            maxLines: null,
                            minLines: 10, // Minimum lines to ensure visibility
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(12.0),
                            ),
                            onChanged: (value) {
                              (context as Element)
                                  .markNeedsBuild(); // Force rebuild
                            },
                          ),
                        ),
                      ),
                    ],
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
  List<TabInfo> _tabs = [];

  @override
  void initState() {
    super.initState();
    _addNewTab(widget.htmlContent);
  }

  String _getAdjustedHtmlContent(String htmlContent) {
    final document = html_parser.parse(htmlContent);
    final title = document.getElementsByTagName('title').isNotEmpty
        ? document.getElementsByTagName('title')[0].text
        : "নতুন ট্যাব";

    return '''
      <!DOCTYPE html>
      <html>
        <head>
          <title>$title</title>
          <style>
            body {
              font-size: 20px;
              font-family: Arial, sans-serif;
              margin: 20px;
              padding: 0;
              background-color: #FFFFFF;
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
        : "নতুন ট্যাব";

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
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
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
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF87CEEB), Color(0xFFADD8E6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          title: const Text(
            'কোড প্রিভিউ',
            style: TextStyle(
              fontFamily: 'NotoSansBengali',
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
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
          actions: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              tooltip: 'নতুন ট্যাব',
              onPressed: () => _addNewTab(widget.htmlContent),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'রিফ্রেশ',
              onPressed: () => _controller.reload(),
            ),
          ],
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF87CEEB)),
                ),
              ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: const Color(0xFF87CEEB),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                tooltip: 'পিছনে',
                onPressed: () async {
                  if (await _controller.canGoBack()) {
                    _controller.goBack();
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
                tooltip: 'সামনে',
                onPressed: () async {
                  if (await _controller.canGoForward()) {
                    _controller.goForward();
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.home, color: Colors.white),
                tooltip: 'হোম',
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
