import 'package:flutter/material.dart';
import 'package:model_maker/parsing_settings/parsing_option_tile.dart';
import 'package:model_maker/parsing_settings/parsing_settings_model.dart';
import 'package:provider/provider.dart';

class ParsingSettings extends StatefulWidget {
  const ParsingSettings({super.key});

  @override
  State<ParsingSettings> createState() => _ParsingSettingsState();
}

class _ParsingSettingsState extends State<ParsingSettings> {
  final textEditingController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final confModel = Provider.of<ParsingSettingsModel>(context, listen: false);

    final modelNameInput = SizedBox(
      width: 200,
      height: 70,
      child: TextField(
        controller: textEditingController,
        onChanged: (value) => confModel.modelName = value,
        decoration: const InputDecoration(
          labelStyle: TextStyle(color: Colors.black),
          labelText: '模型名称(默认 Root)',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(35)),

            borderSide: BorderSide(color: Colors.black, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(35)),
            borderSide: BorderSide(color: Colors.black, width: 2),
          ),
          contentPadding: EdgeInsets.only(left: 20),
        ),
      ),
    );

    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      // color: Colors.white,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          modelNameInput,
          SizedBox(width: 10),
          ParsingOptionTile(
            text: "结构体",
            value: confModel.isUsingStruct,
            onChanged: (bool? newValue) {
              setState(() {
                confModel.isUsingStruct = newValue ?? false;
              });
            },
          ),
          SizedBox(width: 10),
          ParsingOptionTile(
            text: "构造方法",
            value: confModel.supportConstruction,
            onChanged: (bool? newValue) {
              setState(() {
                confModel.supportConstruction = newValue ?? false;
              });
            },
          ),



          SizedBox(width: 20),
          ParsingOptionTile(
            text: "属性public",
            value: confModel.supportPublic,
            onChanged: (bool? newValue) {
              setState(() {
                confModel.supportPublic = newValue ?? false;
              });
            },
          ),
          SizedBox(width: 10),
          ParsingOptionTile(
            text: "驼峰命名",
            value: confModel.isCamelCase,
            onChanged: (bool? newValue) {
              setState(() {
                confModel.isCamelCase = newValue ?? false;
              });
            },
          ),
          

          SizedBox(width: 10),
          ParsingOptionTile(
            text: "属性可选",
            value: confModel.supportOptional,
            onChanged: (bool? newValue) {
              setState(() {
                confModel.supportOptional = newValue ?? false;
              });
            },
          ),

          SizedBox(width: 10),
          ParsingOptionTile(
            text: "注释头",
            value: confModel.addDocComments,
            onChanged: (bool? newValue) {
              setState(() {
                confModel.addDocComments = newValue ?? false;
              });
            },
          ),
        ],
      ),
    );
  }
}
