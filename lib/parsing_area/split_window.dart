import 'package:flutter/material.dart';
import 'package:model_maker/parsing_settings/parsing_settings_model.dart';
import 'package:model_maker/parsing_area/json_model_generator/json_model_generator.dart';
import 'package:model_maker/parsing_area/debouncer.dart';
import 'package:provider/provider.dart';

/// 分体窗口
class SplitWindow extends StatefulWidget {
  const SplitWindow({super.key});
  @override
  _SplitWindowState createState() => _SplitWindowState();
}

class _SplitWindowState extends State<SplitWindow> {
  final Debouncer _debouncer = Debouncer(Duration(seconds: 1));

  /// 初始分割位置为中间
  double _splitPosition = 0.5;

  /// 中间分隔条的宽度
  final double _centerSeplineWidth = 4;

  var textEditingController = TextEditingController();
  var textResultController = TextEditingController();
  late ParsingSettingsModel _confModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _confModel = context.read<ParsingSettingsModel>();
    _confModel.setOnPastedJsonStringChanged((value) {
      textEditingController.text = value;
      _handleConfChange();
    });
    _confModel.addListener(_handleConfChange);
  }

  /// 配置变更后刷新页面数据
  void _handleConfChange() {
    _debouncer.run(() {
      JsonModelGenerator.asyncGenerateModels(textEditingController.text, _confModel)
          .then((data) {
            setState(() {
              textResultController.text = data ?? '';
              outputResult = textResultController.text;
            });
          }) // 成功回调
          .catchError((error) => print('错误: $error')) // 错误回调
          .whenComplete(() => print('操作完成')); // 最终回调
    });
  }

  /// 更改分割线的位置
  void _updateSplitPosition(Offset position) {
    final screenWidth = MediaQuery.of(context).size.width;
    setState(() {
      double dx = position.dx;
      double anchorX = 400.0;
      if (dx < anchorX) {
        dx = anchorX;
      } else if (dx > screenWidth - anchorX - _centerSeplineWidth) {
        dx = screenWidth - anchorX - _centerSeplineWidth;
      }
      _splitPosition = dx / screenWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onPanUpdate: (details) {
            _updateSplitPosition(details.localPosition);
          },
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: constraints.maxWidth * _splitPosition,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(35), // 👈 左下角圆角
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15, 1, 1, 1),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: double.infinity, minWidth: double.infinity),
                      child: Column(
                        children: [
                          Expanded(
                            child: TextField(
                              maxLines: null,
                              decoration: InputDecoration(
                                hintText: "请在此处输入json文本或接口文档",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                              ),
                              controller: textEditingController,
                              onChanged: (value) {
                                _confModel.resetpastedJsonString();
                                _handleConfChange();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: constraints.maxWidth * _splitPosition,
                top: 0,
                bottom: 0,
                width: _centerSeplineWidth,
                // 分隔条宽度
                child: Container(
                  color: Colors.black,
                  child: Center(child: Icon(Icons.drag_handle, size: _centerSeplineWidth * 0.8)),
                ),
              ),
              Positioned(
                left: constraints.maxWidth * _splitPosition + _centerSeplineWidth,
                top: 0,
                bottom: 0,
                width: constraints.maxWidth * (1 - _splitPosition) - _centerSeplineWidth,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(35), // 👈 左下角圆角
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(15, 1, 1, 1),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: double.infinity, minWidth: double.infinity),
                      child: TextField(
                        readOnly: true,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: "模型类生成后显示在此处",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                        controller: textResultController,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
