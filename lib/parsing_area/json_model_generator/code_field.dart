import 'package:flutter/material.dart';
import 'package:code_text_field/code_text_field.dart';

class CodeFieldWithHint extends StatefulWidget {
  final CodeController controller;
  final bool readOnly;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final TextStyle? textStyle;
  final LineNumberStyle? lineNumberStyle;
  final CodeThemeData themeData;

  const CodeFieldWithHint({
    Key? key,
    required this.controller,
    required this.themeData,
    this.readOnly = false,
    this.hintText,
    this.onChanged,
    this.textStyle,
    this.lineNumberStyle,
  }) : super(key: key);

  @override
  _CodeFieldWithHintState createState() => _CodeFieldWithHintState();
}

class _CodeFieldWithHintState extends State<CodeFieldWithHint> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(covariant CodeFieldWithHint oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onTextChanged);
      widget.controller.addListener(_onTextChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {}); // 内容变化时刷新，用于显示/隐藏hint
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CodeTheme(
          data: widget.themeData,
          child: CodeField(
            controller: widget.controller,
            readOnly: widget.readOnly,
            expands: true,
            lineNumberStyle:
                widget.lineNumberStyle ?? const LineNumberStyle(textStyle: TextStyle(color: Colors.white70)),
            textStyle: widget.textStyle ?? const TextStyle(fontFamily: 'SF Mono', fontSize: 16),
            onChanged: widget.onChanged,
          ),
        ),
        if (widget.hintText != null && widget.controller.text.isEmpty)
          Positioned(
            top: 4,
            left: 50,
            child: IgnorePointer(
              ignoring: true,
              child: Text(widget.hintText!, style: TextStyle(color: Colors.grey.shade500, fontSize: 16)),
            ),
          ),
      ],
    );
  }
}
