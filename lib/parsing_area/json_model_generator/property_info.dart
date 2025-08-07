import 'package:model_maker/parsing_area/string_utils.dart';

enum TypeCategory { int, double, string, bool, list, map, unknown }

class PropertyInfo {
  /// 该属性对应的key
  final String key;

  /// 该属性对应的值
  final dynamic value;

  /// 该属性对应的类型
  final TypeCategory type;

  /// 该属性是否可以模型化
  final bool isModelable;

  const PropertyInfo({required this.key, required this.value, required this.type, required this.isModelable});

  static PropertyInfo analyzeType(String key, dynamic data) {
    if (data == null) {
      return PropertyInfo(key: key, value: data, type: TypeCategory.unknown, isModelable: false);
    }

    if (data is List) {
      if (data.isEmpty) {
        // 空数组，元素类型不确定，不能模型化
        return PropertyInfo(key: key, value: data, type: TypeCategory.list, isModelable: false);
      }

      final firstItemType = analyzeType(key, data.first);
      final allSameType = data.every((e) => analyzeType(key, e).type == firstItemType.type);

      // 只有当所有元素都可模型化且类型是map时，才算模型化
      final bool isListModelable =
          allSameType == true &&
          firstItemType.isModelable &&
          firstItemType.type == TypeCategory.map;

      return PropertyInfo(key: key, value: data, type: TypeCategory.list, isModelable: isListModelable);
    }

    if (data is Map) {
      // 字典本身是可模型化的
      return PropertyInfo(key: key, value: data, type: TypeCategory.map, isModelable: true);
    }

    if (data is int) {
      return PropertyInfo(key: key, value: data, type: TypeCategory.int, isModelable: false);
    }
    if (data is double) {
      return PropertyInfo(key: key, value: data, type: TypeCategory.double, isModelable: false);
    }
    if (data is String) {
      return PropertyInfo(key: key, value: data, type: TypeCategory.string, isModelable: false);
    }
    if (data is bool) {
      return PropertyInfo(key: key, value: data, type: TypeCategory.bool, isModelable: false);
    }

    // 其他对象
    return PropertyInfo(key: key, value: data, type: TypeCategory.unknown, isModelable: false);
  }

  /// 返回 Swift 中的类型名称
  String toTypeString() {
    var modelName = createModelName(key);

    String baseType;
    switch (type) {
      case TypeCategory.int:
        baseType = 'Int';
        break;
      case TypeCategory.double:
        baseType = 'Double';
        break;
      case TypeCategory.string:
        baseType = 'String';
        break;
      case TypeCategory.bool:
        baseType = 'Bool';
        break;
      case TypeCategory.list:
        if (isModelable) {
          baseType = '[${modelName}]';
        } else {
          baseType = _analyzeListType(value);
        }

        break;
      case TypeCategory.map:
        baseType = modelName;
        break;
      case TypeCategory.unknown:
        baseType = 'Any';
        break;
    }
    return baseType;
  }

  /// 获取 Swift 中该类型的默认值（仅用于非 optional 情况）
  String defaultTypeValue() {
    switch (type) {
      case TypeCategory.int:
        return '0';
      case TypeCategory.double:
        return '0.0';
      case TypeCategory.string:
        return '""';
      case TypeCategory.bool:
        return 'false';
      case TypeCategory.list:
        return '[]';
      case TypeCategory.map:
        var modelName = createModelName(key);
        return '${modelName}()';
      case TypeCategory.unknown:
        return 'nil'; // fallback
    }
  }

  /// 获取最小数组类型
  static String _analyzeListType(dynamic data) {
    if (data is List) {
      if (data.isEmpty) {
        return '[Any]';
      }

      final firstType = data.first.runtimeType;
      for (var item in data) {
        if (item.runtimeType != firstType) {
          // 存在不同类型
          return '[Any]';
        }
      }

      return '[${firstType}]';
    }
    return '[Any]';
  }

  /// 根据 key 和上层模型名生成当前模型的类型名
  static String createModelName(String key) {
    final pascalKey = StringUtils.underscoreToPascalCase(key);
    return pascalKey;
  }
}
