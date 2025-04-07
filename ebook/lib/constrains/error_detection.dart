import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html_parser;

String? detectHtmlErrors(String htmlContent) {
  try {
    final document = html_parser.parse(htmlContent);

    // Check if it's really an HTML document
    final htmlTag = document.getElementsByTagName('html');
    if (htmlTag.isEmpty) {
      return "HTML ডকুমেন্টে <html> ট্যাগটি নেই।";
    }

    // Check for <head> tag
    final headTag = document.getElementsByTagName('head');
    if (headTag.isEmpty) {
      return "HTML ডকুমেন্টে <head> ট্যাগটি নেই।";
    }

    // Check for <body> tag
    final bodyTag = document.getElementsByTagName('body');
    if (bodyTag.isEmpty) {
      return "HTML ডকুমেন্টে <body> ট্যাগটি নেই।";
    }

    // Optional: check if it's just garbage text
    if (document.documentElement == null ||
        document.body?.text.trim().isEmpty == true) {
      return "এটি একটি সঠিক HTML ডকুমেন্ট নয়।";
    }

    // Check for unclosed or unmatched tags
    final tags = <String, int>{};
    for (var node in document.nodes) {
      _countTags(node, tags);
    }

    for (var entry in tags.entries) {
      if (entry.value != 0) {
        return "অসম্পূর্ণ ট্যাগ: <${entry.key}> খোলা বা বন্ধ করা হয়নি।";
      }
    }

    return null; // No errors
  } catch (e) {
    return "HTML পার্স করতে সমস্যা হয়েছে: $e";
  }
}

void _countTags(dynamic node, Map<String, int> tags) {
  if (node is dom.Element) {
    final tagName = node.localName ?? '';
    if (!tagName.startsWith('!')) {
      tags[tagName] = (tags[tagName] ?? 0) + 1;
      for (var child in node.nodes) {
        _countTags(child, tags);
      }
      tags[tagName] = (tags[tagName] ?? 0) - 1;
    }
  }
}
