import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:highlight/languages/xml.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';

class HtmlCompiler extends StatefulWidget {
  const HtmlCompiler({super.key});

  @override
  State<HtmlCompiler> createState() => _HtmlCompilerState();
}

class _HtmlCompilerState extends State<HtmlCompiler> {
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.play_arrow, color: Colors.green),
                    iconSize: 32.0, // Increase the size of the icon
                    onPressed: () {
                      if (_codeController.text.isNotEmpty) {
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

class HtmlPreview extends StatelessWidget {
  final String htmlContent;
  const HtmlPreview({super.key, required this.htmlContent});
  @override
  Widget build(BuildContext context) {
    final document = html_parser.parse(htmlContent);
    final titleTag = document.head?.getElementsByTagName('title').first;
    final titleContent = titleTag?.text ?? 'HTML Preview';
    final adjustedHtmlContent =
        ''' <!DOCTYPE html> <html> <head> <style> body { font-size: 200%; } </style> </head> <body> ${document.body?.innerHtml ?? ''} </body> </html> ''';
    final controller = WebViewController()
      ..loadRequest(Uri.dataFromString(
        adjustedHtmlContent,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8'),
      ));
    return Scaffold(
      appBar: AppBar(
        title: Text(titleContent.trim().isNotEmpty
            ? titleContent.trim()
            : 'HTML Preview'),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: WebViewWidget(
          controller: controller,
        ),
      ),
    );
  }
}
