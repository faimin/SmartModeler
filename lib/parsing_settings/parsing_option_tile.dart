import 'package:flutter/material.dart';

/// 优化后的带文字圆角 CheckBox 组件
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
    const borderRadiusValue = 30.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadiusValue),
      child: Material(
        color: Colors.black12,
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadiusValue),
          onTap: () => onChanged(!value), // 点击整块切换状态
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black87, width: 1.3),
              borderRadius: BorderRadius.circular(borderRadiusValue),
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
      ),
    );
  }
}
