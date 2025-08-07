import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({Key? key}) : super(key: key);

  final String logoAsset = 'assets/Smarter.png'; // 请替换成你的logo路径
  final String buttonImageAsset = 'assets/github.png'; // 请替换成你的圆形按钮图片路径
  final String descriptionText = 'SmartModeler - Powered by SmartCodable';

  final String urlStr = 'https://github.com/iAmMccc/SmartCodable';

  void _launchURL() async {
    var url = Uri.parse(urlStr);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // 无法打开URL，做出错误处理
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40, // 导航栏高度
      child: Row(
        children: [
          // 左侧logo
          Image.asset(logoAsset, height: 40, width: 40, fit: BoxFit.contain),

          const SizedBox(width: 12),

          // 中间文字描述，使用 Expanded 占满剩余空间
          Expanded(
            child: Text(
              descriptionText,
              style: const TextStyle(fontSize: 24, color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // 右侧圆形按钮
          GestureDetector(
            onTap: _launchURL,
            child: ClipOval(child: Image.asset(buttonImageAsset, height: 40, width: 40, fit: BoxFit.cover)),
          ),
        ],
      ),
    );
  }
}
