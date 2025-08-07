import 'package:model_maker/parsing_area/json_model_generator/property_info.dart';

class ModelInfo {
  ModelInfo({required this.typeName, required this.properties});

  String typeName;
  List<PropertyInfo> properties;

  @override
  String toString() {
    return _toStringWithIndent();
  }

  String _toStringWithIndent([int indent = 0]) {
    final indentStr = '  ' * indent;
    final nextIndentStr = '  ' * (indent + 1);

    final propertiesStr =
        properties.isEmpty ? '[]' : '[\n${properties.map((e) => '$nextIndentStr  $e').join(',\n')}\n$nextIndentStr]';

    return '''$ModelInfo(
$nextIndentStr  typeName: $typeName,
$nextIndentStr  properties: $propertiesStr
$indentStr)''';
  }
}

/// 属性信息: 一个类/结构体中的每一个字段（如 name, age, address）都会对应一个 PropertyInfo 实例。
// class PropertyInfo {
//   /// 属性名
//   String key;

//   /// 原始值（可以是 Map/List），用于结构解析
//   dynamic value;

//   /// 属性类型
//   TypeAnalysisResult type;



//   PropertyInfo({required this.key, required this.value, required this.type});

//   @override
//   String toString() {
//     return 'PropertyInfo(key: $key, value:$value, type: $type';
//   }
// }
