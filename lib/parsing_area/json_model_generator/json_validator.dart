import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:model_maker/parsing_area/string_utils.dart';

/** TO DO
 * 1. 后续支持智能补全，非法json格式的智能补全。
 * 2. 提供更智能的错误格式的说明信息。
*/

/// 一个用于校验和解析 JSON 字符串的工具类。
class JsonValidator {
  /// 尝试将 JSON 字符串解析为 Dart 对象（Map 或 List）。
  ///
  /// - 在 Web 平台：会使用 [StringUtils.replaceZerosInJson] 方法预处理，修复非法的零值。
  /// - 解析成功：返回解析后的对象（`Map<String, dynamic>` 或 `List<dynamic>`）。
  /// - 解析失败：返回错误信息字符串，而不是抛出异常。
  ///
  /// ⚠️ 仅用于“安全解析”（即失败时不抛异常）。如果你希望在解析失败时抛出异常，
  /// 请直接使用 `JsonDecoder().convert(...)` 或 `json.decode(...)` 方法。

  static dynamic tryParseJson(String? jsonString) {
    if (jsonString == null || jsonString.trim().isEmpty) {
      throw 'JSON 格式错误：内容不能为空';
    }

    try {
      final formatted = !kIsWeb ? jsonString : StringUtils.replaceZerosInJson(jsonString);
      var obj = json.decode(formatted);

      if (obj is! Map && obj is! List) {
        throw 'JSON 格式错误：顶层必须是对象 {} 或数组 []';
      }
      return obj;
    } catch (e) {
      // 抛出格式化好的错误提示
      throw _parseJsonError(e.toString(), jsonString);
    }
  }

  /// 对json内容进行格式化
  static String tryFormatJson(String? input) {
    try {
      var obj = JsonValidator.tryParseJson(input); // 这里用你的方法
      print(obj);
      var format = const JsonEncoder.withIndent('  ').convert(obj);
      print(format);
      return format;
    } catch (e) {
      throw '$e'; // 返回错误信息字符串
    }
  }

  /// 根据异常信息和源文本，生成用户友好的错误提示字符串
  static String _parseJsonError(String errorMsg, String? jsonString) {
    // 尝试提取行列信息
    final regex = RegExp(r'line (\d+) column (\d+)');
    final match = regex.firstMatch(errorMsg);

    // 有行列信息，根据row 和 column 做可读提示
    if (match != null && jsonString != null) {
      final line = int.parse(match.group(1)!);
      final column = int.parse(match.group(2)!);

      final context = _getErrorContext(jsonString, line);

      final guess = _guessErrorType(errorMsg);

      return '❌ JSON 格式错误\n'
          '系统检测位置：第 $line 行，第 $column 列\n'
          '$guess\n\n'
          '附近内容：\n$context\n'
          '系统提示：$errorMsg';
    }

    // 没有行列信息，做关键词判断
    if (errorMsg.contains("Expected ':'")) {
      return '❌ JSON 格式错误\n可能问题：属性名后面缺少冒号 (:)。\n\n系统提示：$errorMsg';
    } else if (errorMsg.contains("Unexpected token '}'")) {
      return '❌ JSON 格式错误\n可能问题：属性后缺少值或多余的逗号。\n\n系统提示：$errorMsg';
    } else if (errorMsg.contains("Unexpected end of input")) {
      return '❌ JSON 格式错误\n可能问题：JSON 数据不完整，缺少结尾括号。\n\n系统提示：$errorMsg';
    } else {
      return '❌ JSON 格式错误\n请检查括号、引号、逗号是否正确。\n\n系统提示：$errorMsg';
    }
  }

  /// 获取出错行的上下文内容（前2行到当前行）
  static String _getErrorContext(String jsonString, int line) {
    final lines = jsonString.split('\n');
    String context = '';
    for (int i = line - 2; i <= line; i++) {
      if (i >= 0 && i < lines.length) {
        String prefix = (i + 1).toString().padLeft(2) + ' | ';
        String text = lines[i];
        if (i == line - 1) {
          text += '   ← ⚠ 出错位置';
        }
        context += prefix + text + '\n';
      }
    }
    return context;
  }

  /// 根据错误信息猜测错误类型
  static String _guessErrorType(String errorMsg) {
    if (errorMsg.contains('Expected \':\'')) {
      return '可能问题：属性名后面缺少冒号 (:)';
    } else if (errorMsg.contains('Unexpected token')) {
      return '可能问题：多余的符号或缺少逗号';
    } else {
      return '可能问题：请检查括号、引号、逗号是否正确';
    }
  }
}
