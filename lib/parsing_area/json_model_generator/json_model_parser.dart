import 'package:model_maker/parsing_area/json_model_generator/property_info.dart';
import 'package:model_maker/parsing_area/json_model_generator/model_info.dart';
import 'package:model_maker/parsing_area/string_utils.dart';
import 'package:model_maker/parsing_settings/parsing_settings_model.dart';

class JsonModelParser {
  static List<ModelInfo>? toModels(dynamic data, ParsingSettingsModel settings) {
    var name = createModelName(key: settings.modelName);

    if (data is Map) {
      // 如果是 Map，直接处理
      return Parser.toModels(data, name);
    } else if (data is List) {
      if (data.isEmpty) return null;
      // 如果是 List 且每个元素都是 Map，处理第一个
      if (data.every((item) => item is Map)) {
        return Parser.toModels(data, name);
      }
    }
    // 否则不是可解析的结构，返回 null
    return null;
  }

  /// 根据 key 和上层模型名生成当前模型的类型名
  static String createModelName({String? key}) {
    final pascalKey = StringUtils.underscoreToPascalCase(key ?? '').trim();

    // 如果 key 无法生成合法名称，则使用默认名
    final baseName = pascalKey.isEmpty ? defaultModelName : pascalKey;

    return baseName;
  }
}

class Parser {
  static List<ModelInfo>? toModels(dynamic data, String key) {
    if (data is! Map) return null;

    final properties = <PropertyInfo>[];
    var models = <ModelInfo>[];

    final modelName = JsonModelParser.createModelName(key: key);
    var model = ModelInfo(typeName: modelName, properties: properties);

    data.forEach((key, value) {
      var result = PropertyInfo.analyzeType(key, value);

      var property = PropertyInfo.analyzeType(key, value);
      properties.add(property);
      switch (result.type) {
        case TypeCategory.map:
          var subModels = Parser.toModels(value, key);
          if (subModels != null) {
            models = models + subModels;
          }
          break;
        case TypeCategory.list:
          if (result.isModelable) {
            var list = value as List;
            var firstMap = list.first;
            var subModels = Parser.toModels(firstMap, key);
            if (subModels != null) {
              models = models + subModels;
            }
          }

          break;
        default:
          break;
      }
    });
    model.properties = properties;
    models.add(model);
    return models;
  }
}

class ModelFormatter {
  static String tabSpace = "    ";

  /// 模型信息转化成模型String
  static String toModelsString(List<ModelInfo> models, ParsingSettingsModel settings) {
    var modelStr = "import SmartCodable\n\n\n";

    for (var model in models.reversed) {
      /// 类声明所在的那一行
      modelStr += _headerLine(model, settings);

      // 属性信息
      modelStr += _properties(model, settings);

      modelStr += _codableMappingLines(model, settings);

      /// 构造方法
      modelStr += _constructionMethod(model, settings);

      /// required init
      modelStr += _requiredInit(settings);

      // 尾部
      modelStr += _footererLine();
    }

    return modelStr;
  }

  /// 类声明所在的那一行
  static String _headerLine(ModelInfo model, ParsingSettingsModel setting) {
    String headerLine = "";
    if (setting.supportPublic) {
      headerLine += "public ";
    }

    if (setting.isUsingStruct) {
      headerLine += 'struct ${model.typeName} : SmartCodable {\n';
    } else {
      headerLine += 'class ${model.typeName}: SmartCodable {\n';
    }
    return headerLine;
  }

  /// 属性行列
  static String _properties(ModelInfo model, ParsingSettingsModel settings) {
    final buffer = StringBuffer('\n');

    for (final property in model.properties) {
      final key = settings.isCamelCase ? StringUtils.underscoreToCamelCase(property.key) : property.key;

      // 加文档注释
      if (settings.addDocComments) {
        buffer.writeln('$tabSpace/// TODO: description');
      }

      final visibility = settings.supportPublic ? 'public var' : 'var';

      String declaration = "";

      // 是数组类型

      String typeStr = property.toTypeString();

      if (settings.supportOptional) {
        declaration = '$visibility $key: $typeStr?';
      } else {
        final defaultValue = property.defaultTypeValue();
        declaration = '$visibility $key: $typeStr = ${defaultValue}';
      }
      buffer.writeln('$tabSpace$declaration');
    }

    return buffer.toString();
  }

  /// 检查SmartCodable要求的映射关系
  static String _codableMappingLines(ModelInfo modelInfo, ParsingSettingsModel settings) {
    var modelStr = "";

    /// 是否有需要映射的属性
    var hasNeedMappingKeyProperties =
        modelInfo.properties
            .where((property) => property.key != StringUtils.underscoreToCamelCase(property.key))
            .isNotEmpty;

    /// 检查SmartCodable要求的映射关系
    if (settings.isCamelCase && hasNeedMappingKeyProperties) {
      var mappingStr = "\n${tabSpace}static func mappingForKey() -> [SmartKeyTransformer]? {\n";
      mappingStr += "${tabSpace}${tabSpace}[\n";
      for (var property in modelInfo.properties) {
        var camelKey = StringUtils.underscoreToCamelCase(property.key);
        if (camelKey == property.key) {
          continue;
        }
        mappingStr += "${tabSpace}${tabSpace}${tabSpace}CodingKeys.$camelKey <--- \"${property.key}\",\n";
      }
      mappingStr += "${tabSpace}${tabSpace}]\n";
      mappingStr += "${tabSpace}}\n";

      modelStr += mappingStr;
    }

    return modelStr;
  }

  /// 构造方法
  static String _constructionMethod(ModelInfo modelInfo, ParsingSettingsModel settings) {
    if (!settings.supportConstruction || modelInfo.properties.isEmpty) return '';

    final indent = tabSpace;
    final innerIndent = tabSpace * 2;
    final buffer = StringBuffer();
    buffer.write('\n');

    final initKeyword = settings.supportPublic ? 'public init' : 'init';
    buffer.write('$indent$initKeyword(');

    // 参数构建
    final params = <String>[];
    for (var property in modelInfo.properties) {
      final key = settings.isCamelCase ? StringUtils.underscoreToCamelCase(property.key) : property.key;
      final type = property.type;
      final isOptional = settings.supportOptional ? '?' : '';
      params.add('$key: $type$isOptional');
    }

    buffer.write(params.join(', '));
    buffer.writeln(') {');

    // 构造体内容
    for (var property in modelInfo.properties) {
      final key = settings.isCamelCase ? StringUtils.underscoreToCamelCase(property.key) : property.key;
      buffer.writeln('${innerIndent}self.$key = $key');
    }

    buffer.writeln('$indent}\n');

    buffer.writeln('${indent}init() { }');

    return buffer.toString();
  }

  /// init方法
  static String _requiredInit(ParsingSettingsModel settings) {
    if (settings.isUsingStruct) {
      return "";
    }
    return "${tabSpace}required init() { }\n";
  }

  static String _footererLine() {
    return "}\n\n";
  }
}
