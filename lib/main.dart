// ignore_for_file: use_key_in_widget_constructors, depend_on_referenced_packages,library_private_types_in_public_api

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zpw/modules/main/zpw_main_state.dart';
import 'package:zpw/modules/splash/zpw_splash_view.dart';
import 'package:zpw/utils/zpw_ads_utils.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main()   {
  Get.lazyPut(() => MainState());
  // 绑定引擎
  WidgetsFlutterBinding.ensureInitialized();
  ZpwAdsUtils.setAdEvent();
  runApp(
    MyApp(),
  );
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
          if (state.mode == IndicatorMode.processing ||
              state.mode == IndicatorMode.ready) {
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
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));
    _setEasyRefresh();
    super.initState();
  }

  final easyLoad = EasyLoading.init();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) {
        return GetMaterialApp(
            title: 'AI照片王',
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
            //NotePage(),
            builder: (context, widget) {
              widget = easyLoad(context, widget);
              widget = MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1)),
                child: widget,
              );
              return widget;
            });
      },
    );
  }
}
