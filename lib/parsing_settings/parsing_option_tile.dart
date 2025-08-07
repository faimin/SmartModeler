import 'package:flutter/material.dart';

/// 带文字的checkBox
class ParsingOptionTile extends StatelessWidget {
  final String text;
  final bool value;
  final ValueChanged<bool?> onChanged;
  final Color? activeColor;
  final TextStyle textStyle;
  final double spacing;

  const ParsingOptionTile({
    Key? key,
    required this.text,
    required this.value,
    required this.onChanged,
    this.activeColor = Colors.black,
    this.textStyle = const TextStyle(color: Colors.black, fontSize: 14),
    this.spacing = 3.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () => onChanged(!value), // 点击整块切换状态
        child: Container(
          padding: const EdgeInsets.only(left: 8, right: 10, top: 6, bottom: 6),
          decoration: BoxDecoration(
            color: Colors.black12,
            border: Border.all(color: Colors.black87),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 20,
                width: 20,
                child: Checkbox(
                  value: value,
                  onChanged: onChanged,
                  activeColor: activeColor,
                  shape: const CircleBorder(),
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                ),
              ),
              SizedBox(width: spacing),
              Text(text, style: textStyle),
            ],
          ),
        ),
      ),
    );
  }
}
