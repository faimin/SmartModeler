import 'package:flutter/material.dart';

final defaultModelName = "Root";

String? outputResult;

/// 配置信息
class ParsingSettingsModel extends ChangeNotifier {
  /// 是否使用结构体
  bool _isUsingStruct = true;
  /// 支持构造方法
  bool _supportConstruction = false;

  /// 是否支持驼峰命名
  bool _isCamelCase = false;
  /// 属性是否public
  bool _supportPublic = false;
  /// 属性是否可选
  bool _supportOptional = false;
  
  /// 是否添加注释
  bool _addDocComments = false;

  /// 自定义的模型名称
  String _modelName = "";
  /// 复制的json
  String _pastedJsonString = "";

  // Getter 方法
  bool get isUsingStruct => _isUsingStruct;
  bool get supportConstruction => _supportConstruction;

  bool get isCamelCase => _isCamelCase;
  bool get supportPublic => _supportPublic;

  bool get supportOptional => _supportOptional;
  bool get addDocComments => _addDocComments;


  String get modelName => _modelName;
  String get pastedJsonString => _pastedJsonString;

  set supportOptional(bool value) {
    if (_supportOptional != value) {
      _supportOptional = value;
      notifyListeners();
    }
  }

    set addDocComments(bool value) {
    if (_addDocComments != value) {
      _addDocComments = value;
      notifyListeners();
    }
  }




  set isCamelCase(bool value) {
    if (_isCamelCase != value) {
      _isCamelCase = value;
      notifyListeners();
    }
  }

  set isUsingStruct(bool value) {
    if (_isUsingStruct != value) {
      _isUsingStruct = value;
      notifyListeners();
    }
  }

  set supportPublic(bool value) {
    if (_supportPublic != value) {
      _supportPublic = value;
      notifyListeners();
    }
  }

  set modelName(String value) {
    if (_modelName != value) {
      _modelName = value;
      notifyListeners();
    }
  }

  set pastedJsonString(String value) {
    if (_pastedJsonString != value) {
      _pastedJsonString = value;
      _onPastedJsonStringChanged?.call(value);
    }
  }

  set supportConstruction(bool value) {
    if (_supportConstruction != value) {
      _supportConstruction = value;
      notifyListeners();
    }
  }

  void resetpastedJsonString() {
    if (_pastedJsonString.isNotEmpty) {
      _pastedJsonString = "";
    }
  }

  Function(String)? _onPastedJsonStringChanged;

  // 设置 JSON 字符串变化回调
  void setOnPastedJsonStringChanged(Function(String) callback) {
    _onPastedJsonStringChanged = callback;
  }
}
