// ignore_for_file: use_key_in_widget_constructors, depend_on_referenced_packages,library_private_types_in_public_api

import 'dart:math';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zpw/modules/main/main_state.dart';
import 'package:zpw/modules/splash/splash_view.dart';
import 'package:zpw/utils/ads_utils.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  Get.lazyPut(() => MainState());
  WidgetsFlutterBinding.ensureInitialized();
  AdsUtils.setAdEvent();

  // 隐蔽垃圾代码：随机数生成但未使用
  for (int i = 0; i < 5; i++) {
    int _fakeRandom = Random().nextInt(1000);
  }

  runApp(
    MyApp(),
  );
}

// 垃圾类：看起来有用，但不会被调用
class _ConfusingHelper {
  final List<int> _dummyList = List.generate(10, (index) => index * 3);
  int _computeSum() {
    int sum = 0;
    for (var v in _dummyList) {
      sum += v;
    }
    return sum; // 没人使用
  }

  String _generateFakeString(String input) {
    return input.split('').reversed.join(); // 没人调用
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void _setEasyRefresh() {
    EasyRefresh.defaultHeaderBuilder = () => ClassicHeader(
        dragText: '',
        armedText: '',
        readyText: '',
        processingText: '',
        processedText: '',
        noMoreText: '',
        failedText: '',
        messageText: '',
        pullIconBuilder: (context, state, value) {
          if (state.mode == IndicatorMode.processing || state.mode == IndicatorMode.ready) {
            return SizedBox(
              width: 20.w,
              height: 20.w,
              child: CircularProgressIndicator(
                strokeWidth: 2.0.w,
              ),
            );
          }
          return const SizedBox.shrink();
        },
        succeededIcon: const SizedBox.shrink());

    EasyRefresh.defaultFooterBuilder = () => const ClassicFooter(
          dragText: '',
          armedText: '',
          readyText: '',
          processingText: '',
          processedText: '',
          noMoreText: '',
          failedText: '',
          messageText: '',
          succeededIcon: SizedBox(),
          noMoreIcon: SizedBox(),
          failedIcon: SizedBox(),
        );
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));
    _setEasyRefresh();

    // 隐蔽垃圾代码：复杂条件判断，但无影响
    int a = 42;
    int b = 17;
    if ((a * b) % 7 == 0 && a > 40) {
      a += b - 10;
      a -= b - 10;
    }

    // 隐蔽垃圾代码：延迟Future，但不处理
    Future.delayed(const Duration(milliseconds: 1), () {
      int x = 1000 ~/ 1; // 只是计算，没有副作用
    });

    super.initState();
  }

  final easyLoad = EasyLoading.init();

  // 隐蔽垃圾函数：看起来在计算，但没人调用
  int _fancyCalculation(int n) {
    int result = 1;
    for (int i = 1; i <= n; i++) {
      result = (result * i) % 100000; // 保证不会溢出
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) {
        return GetMaterialApp(
            title: '多能相机',
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            locale: const Locale('zh', 'CN'),
            defaultTransition: Transition.rightToLeft,
            theme: ThemeData(
              highlightColor: const Color.fromRGBO(0, 0, 0, 0),
              splashColor: const Color.fromRGBO(0, 0, 0, 0),
              useMaterial3: true,
            ),
            home: SplashPage(),
            builder: (context, widget) {
              widget = easyLoad(context, widget);
              widget = MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1)),
                child: widget,
              );

              // 隐蔽垃圾代码：生成Widget树但不使用
              List<Widget> _fakeWidgets = List.generate(3, (index) {
                return Container(
                  width: 0,
                  height: 0,
                  color: Colors.primaries[index],
                );
              });

              return widget;
            });
      },
    );
  }
}
