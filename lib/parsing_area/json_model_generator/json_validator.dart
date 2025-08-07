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
      throw FormatException('JSON 字符串不能为空');
    }

    try {
      final formatted = !kIsWeb ? jsonString : StringUtils.replaceZerosInJson(jsonString);
      var obj = json.decode(formatted);
      // 不是 Map 或 List，无法生成模型
      if (obj is! Map && obj is! List) {
        throw FormatException('JSON 字符串是非法字符串');
      } else {
        return obj;
      }
    } catch (e) {
      throw '$e'; // 返回错误信息字符串
    }
  }
}
