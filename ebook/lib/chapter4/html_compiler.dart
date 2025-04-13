import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:highlight/languages/xml.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';

class HtmlCompilerWithTabs extends StatefulWidget {
  const HtmlCompilerWithTabs({super.key});

  @override
  State<HtmlCompilerWithTabs> createState() => _HtmlCompilerWithTabsState();
}

class _HtmlCompilerWithTabsState extends State<HtmlCompilerWithTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late CodeController _codeController;
  late WebViewController _webViewController;
  String _htmlPreviewContent = "";
  String? _lastError;
  bool _isWebViewInitialized = false;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _codeController = CodeController(
      text:
          "<!DOCTYPE html>\n<html>\n<head>\n<title>পৃষ্ঠার শিরোনাম</title>\n</head>\n<body>\n<h1>হ্যালো বিশ্ব</h1>\n</body>\n</html>",
      language: xml,
    );

    _initializeWebViewController();
  }

  Future<void> _initializeWebViewController() async {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            setState(() {
              _isWebViewInitialized = true;
            });
          },
        ),
      );

    await _compileAndPreview();
  }

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
      if (!selfClosingTags.contains(tag)) openTags.add(tag);
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

    return null;
  }

  Future<void> _compileAndPreview() async {
    final error = detectHtmlErrors(_codeController.text);
    setState(() {
      _lastError = error;
    });

    if (error == null) {
      final html = _getAdjustedHtmlContent(_codeController.text);
      final previewUrl = Uri.dataFromString(
        html,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8'),
      ).toString();

      setState(() {
        _htmlPreviewContent = previewUrl;
      });

      if (_webViewController != null) {
        await _webViewController.loadRequest(Uri.parse(previewUrl));
      }
    }
  }

  String _getAdjustedHtmlContent(String htmlContent) {
    final document = html_parser.parse(htmlContent);
    return '''
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <style>
            body {
              font-family: Arial, sans-serif;
              margin: 20px;
              line-height: 1.6;
              font-size: 16px;
            }
            .error-message {
              color: red;
              padding: 20px;
              border: 1px dashed red;
              margin: 10px;
            }
          </style>
        </head>
        <body>
          ${_lastError != null ? '<div class="error-message">$_lastError</div>' : ''}
          ${document.body?.innerHtml ?? ''}
        </body>
      </html>
    ''';
  }

  @override
  void dispose() {
    _tabController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header with Tabs
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.blue.shade800,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.blue.shade800,
                  tabs: const [
                    Tab(text: 'এডিটর'),
                    Tab(text: 'আউটপুট'),
                  ],
                ),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Editor Tab
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            "নিজে চেষ্টা করুন",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.play_circle,
                                color: Colors.green),
                            onPressed: _compileAndPreview,
                          ),
                        ],
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(4.0),
                            color: Colors.black,
                          ),
                          child: CodeField(
                            controller: _codeController,
                            textStyle: const TextStyle(
                              fontFamily: 'SourceCodePro',
                              fontSize: 14,
                              color: Colors.white,
                            ),
                            minLines: 10,
                            maxLines: 20,
                            onChanged: (_) => _compileAndPreview(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '</>write your code here',
                        style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),

                // Output Tab
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: _isWebViewInitialized
                      ? WebViewWidget(controller: _webViewController)
                      : const Center(child: CircularProgressIndicator()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
