import 'package:flutter/material.dart';
import 'package:model_maker/parsing_settings/parsing_settings_model.dart';
import 'package:model_maker/parsing_area/split_window.dart';
import 'package:model_maker/parsing_settings/parsing_settings.dart';
import 'package:model_maker/page_header/page_header.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (context) => ParsingSettingsModel(), child: MaterialApp(home: MyApp())));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: _buildHome(context)));
  }

  Widget _buildHome(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          PageHeader(),
          SizedBox(height: 10),
          ParsingSettings(),
          SizedBox(height: 4),
          Expanded(child: Container(width: double.infinity, child: SplitWindow(key: key))),
        ],
      ),
    );
  }
}


/** ToDo List
 * 1. [done]构造方法的bug
 * 2. [done]Any相关的类型添加@SmartAny
 * 3. json解析报错提示
 * 4. json格式化方式
 * 5. json智能补全
 * 
*/