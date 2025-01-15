// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zpw/base/base_stateful_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:zpw/common/style.dart';
import 'my_web_view_logic.dart';


class MyWebViewPage extends BaseStatefulWidget {
  late String titleStr;
  late String htmlUrl;

  // ignore: use_key_in_widget_constructors
  MyWebViewPage({this.titleStr = "", this.htmlUrl = ""});

  @override
  BaseWidgetState<MyWebViewPage> getState() => _MyWebViewPageState();
}

class _MyWebViewPageState extends BaseWidgetState<MyWebViewPage> {
  final logic = Get.put(MyWebViewLogic());

  double progressValue = 0.0;
  final WebViewController controller = WebViewController()
    ..setBackgroundColor(const Color(0x00000000));

  @override
  void initState() {
    super.initState();
    // controller.setBackgroundColor(const Color(0x00000000));
    controller.setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // loadProgress(progress);
          loadProgress(progress);
        },
        onPageStarted: (String url) {
          // Log.i("=======112333");
        },
        onPageFinished: (String url) {
          // Log.i("=======1123334444");
        },
        onWebResourceError: (WebResourceError error) {},
      ),
    );

    if (WebViewPlatform.instance is AndroidWebViewPlatform) {
      final AndroidWebViewController androidController =
          controller.platform as AndroidWebViewController;
      //textZoom 默认值是 100
      if (widget.titleStr == "隐私协议") {
        androidController.setTextZoom(100);
      }else{
        androidController.setTextZoom(250);
      }

    }

    loadHtmlAction();
  }

  void loadHtmlAction() {
    controller.loadRequest(Uri.parse(widget.htmlUrl));
    // loadRequest(Uri.dataFromString(widget.htmlUrl, encoding: Encoding.getByName('utf-8'),mimeType: 'text/html'),);
  }

  // ..javascriptMode: JavascriptMode.unrestricted,

  loadProgress(int value) {
    if (mounted) {
      setState(() {
        progressValue = value / 100.0;
      });
    }
  }

  double xx = 0.3;

  @override
  Widget initDefaultBuild(BuildContext context) {
    return Column(
      children: [
        YAppBar(title: widget.titleStr),
        progressValue > 0 && progressValue < 1
            ? LinearProgressIndicator(
                value: progressValue,
                minHeight: 2,
                backgroundColor: ColorPlate.themeBgColor,
                valueColor: const AlwaysStoppedAnimation(ColorPlate.themeColor),
              )
            : Container(),
        Expanded(
          child: WebViewWidget(
            controller: controller,
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    Get.delete<MyWebViewLogic>();
    super.dispose();
  }
}
