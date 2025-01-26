import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';

class CodeFieldWithToggle extends StatefulWidget {
  final String text; // Text to display in the CodeField

  const CodeFieldWithToggle({super.key, required this.text});

  @override
  // ignore: library_private_types_in_public_api
  _CodeFieldWithToggleState createState() => _CodeFieldWithToggleState();
}

class _CodeFieldWithToggleState extends State<CodeFieldWithToggle> {
  bool _isTextVisible = true; // Tracks whether the code is visible
  late CodeController _codeController;
  String text = 'Your code is hidden';

  @override
  void initState() {
    super.initState();

    // Initialize CodeController with the provided text
    _codeController = CodeController(
      text: widget.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2), // Add border
        borderRadius: BorderRadius.circular(8), // Rounded corners
      ),
      child: Stack(
        children: [
          // Show CodeField if text is visible
          if (_isTextVisible)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CodeField(
                controller: _codeController,
                expands: false, // Adjust according to layout needs
                textStyle: const TextStyle(fontSize: 16), // Adjust font size
                minLines: 5, // Minimum height for the CodeField
                maxLines: null, // Allow dynamic height for long text
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CodeField(
                controller: CodeController(text: text),
                expands: false, // Adjust according to layout needs
                textStyle: const TextStyle(fontSize: 16), // Adjust font size
                minLines: 5, // Minimum height for the CodeField
                maxLines: null, // Allow dynamic height for long text
              ),
            ),

          // Visibility toggle button
          Positioned(
            right: 10,
            bottom: 10,
            child: IconButton(
              icon: Icon(
                _isTextVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _isTextVisible = !_isTextVisible;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
