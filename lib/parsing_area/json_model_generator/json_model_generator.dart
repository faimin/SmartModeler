import 'package:model_maker/parsing_area/json_model_generator/json_model_parser.dart';
import 'package:model_maker/parsing_area/json_model_generator/json_validator.dart';
import 'package:model_maker/parsing_settings/parsing_settings_model.dart';
import 'package:model_maker/parsing_area/json_model_generator/model_info.dart';

final todoKey = '// TODO: ';

/** JsonModelGenerator 功能
 * 1. 校验JSON的格式，并提供智能补全。
 * 2. 通过Value获取类型，以及对应的默认值。判断当前值是否是subModel。
 * 3. JSON转Modelinfo，包含生成propertyInfo，
 * 4. Modelinfo转格式化的String。
*/

/// JSON工具类
class JsonModelGenerator {
  /// 异步获取数据
  static Future<String?> asyncGenerateModels(String? jsonStr, ParsingSettingsModel conf) async {
    return Future(() {
      var jsonRes = _generateModels(jsonStr, conf);
      return jsonRes;
    });
  }

  /// 转换成模型信息
  static String? _generateModels(String? jsonStr, ParsingSettingsModel setttings) {
    try {
      // 1. 校验json，转成obj
      var dynamicObj = JsonValidator.tryParseJson(jsonStr);

      // 2. 转成模型数组（考虑到可能存在的嵌套模型，返回数组）
      List<ModelInfo>? models = JsonModelParser.toModels(dynamicObj, setttings);

      if (models == null) {
        return null;
      } else {
        var format = ModelFormatter.toModelsString(models, setttings);
        return format;
      }
    } catch (e) {
      return "${e}";
    }
  }
}
