import 'package:flutter/material.dart';

class ZpwSysSize {
  static const double zpwAvatar = 56;
  // static const double iconBig = 40;
  static const double zpwIconNormal = 24;
  // static const double big = 18;
  // static const double normal = 16;
  // static const double small = 12;
  static const double zpwIconBig = 40;
  static const double zpwBig = 16;
  static const double zpwNormal = 14;
  static const double zpwSmall = 12;
}

class ZpwStandardTextStyle {
  static const TextStyle zpwBig = TextStyle(
    fontWeight: ZpwTKFontWeight.zpwMax6,
    fontSize: ZpwSysSize.zpwBig,
    inherit: true,
    color: Colors.grey,
  );
  static const TextStyle zpwBigWithOpacity = TextStyle(
    color: Colors.white, //const Color.fromRGBO(0xff, 0xff, 0xff, .66),
    fontWeight: ZpwTKFontWeight.zpwMax6,
    fontSize: ZpwSysSize.zpwBig,
    inherit: true,
  );
  static const TextStyle zpwNormalW = TextStyle(
    fontWeight: ZpwTKFontWeight.zpwMax6,
    fontSize: ZpwSysSize.zpwNormal,
    inherit: true,
  );
  static const TextStyle zpwNormal = TextStyle(
    fontWeight: ZpwTKFontWeight.zpwNormal,
    fontSize: ZpwSysSize.zpwNormal,
    inherit: true,
  );
  static const TextStyle zpwNormalWithOpacity = TextStyle(
    color: Color.fromRGBO(0xff, 0xff, 0xff, .66),
    fontWeight: ZpwTKFontWeight.zpwNormal,
    fontSize: ZpwSysSize.zpwNormal,
    inherit: true,
  );
  static const TextStyle zpwSmall = TextStyle(
    fontWeight: ZpwTKFontWeight.zpwNormal,
    fontSize: ZpwSysSize.zpwSmall,
    inherit: true,
  );
  static const TextStyle zpwSmallWithOpacity = TextStyle(
    color: Color.fromRGBO(0xff, 0xff, 0xff, .66),
    fontWeight: ZpwTKFontWeight.zpwNormal,
    fontSize: ZpwSysSize.zpwSmall,
    inherit: true,
  );
}

class ZpwColorPlate {
  static const Color zpwDotRed = Color(0xffFF5F00);
  static const Color zpwDotGreen = Color(0xff32CD98);

  // 配色
  static const Color zpwOrange = Color(0xffFFC459);
  static const Color zpwYellow = Color(0xffF1E300);
  static const Color zpwGreen = Color(0xff7ED321);
  static const Color zpwRed = Color(0xffEB3838);
  static const Color zpwDarkGray = Color(0xff4A4A4A);
  static const Color zpwGray = Color(0xff9b9b9b);
  static const Color zpwLightGray = Color(0xfff5f5f4);
  static const Color zpwBlack = Color(0xff1E1E1E);
  static const Color zpwWhite = Color(0xffffffff);
  static const Color zpwClear = Color(0);
  static const Color zpwDefaultColor = Color(0xffCCCCCC);
  static const Color zpwHomeNameColor = Color(0xff666666);
  static const Color zpwSearchTextColor = Color(0xff999999);
  static const Color zpwThreeColor = Color(0xff333333);
  static const Color zpwCommonGray = Color(0xffA2AAAE);
  static const Color zpwCommonGreen = Color(0XFF36D58C);

  /// 页面背景色
  static const Color zpwPageBgColor = Color(0xffF5F8FC);
  static const Color zpwTitleColor = Color(0xff191919);
  static const Color zpwDescColor = Color(0xff808080);
  static const Color zpwScanDescColor = Color(0xff676767);

  /// 深色背景
  static const Color zpwBack1 = Color(0xff1D1F22);

  /// 比深色背景略深一点
  static const Color zpwBack2 = Color(0xff121314);

  static const Color zpwDefaultGreenColor = Color(0xffBCFA0E);
  //白色的40%透明度
  static Color zpwFfffffOpacity4 = const Color(0xffFFFFFF).withOpacity(0.4);
  //白色的60%透明度
  static Color zpwFfffffOpacity6 = const Color(0xffFFFFFF).withOpacity(0.6);
  //白色的20%透明度
  static Color zpwFfffffOpacity2 = const Color(0xffFFFFFF).withOpacity(0.2);
  //纯白色
  static const Color zpwFffffffOpacity1 = Color(0xffFFFFFF);
  //主题颜色
  static const Color zpwThemeColor = Color(0xff7FE7F9);
  static const Color zpwTabbarThemeColor = Color(0xFF191919);
  // tabbar未选中时的文字颜色
  static const Color zpwTabbarTextColorNormal = Color(0xffB3B3B3);
  // 主题背景颜色
  static const Color zpwThemeBgColor = Color(0xffF4F5F9);
  // 文字灰色
  static const Color zpwCommonGrayColor = Color(0xffB8B9BB);
  // 深灰色
  static const Color zpwCommonHighGrayColor = Color(0xff626A7B);

  //999999
  static const Color zpwSixNineColor = Color(0xff4C4C4C);
  //66666
  static const Color zpwSixSixColor = Color(0xff666666);
  //33333
  static const Color zpwSixThreeColor = Color(0xff333333);
  //纯黑色 0000000
  static const Color zpwSixZeroColor = Color(0xff000000);
  //纯黑色 1A
  static const Color zpwSixZero1AColor = Color(0xff1A1A1A);
  //纯黑色 1111111
  static const Color zpwSixZero1Color = Color(0xff111111);
  //纯黑色 22222222
  static const Color zpwSixZero2Color = Color(0xff222222);
  //灰色 EEEEEE
  static const Color zpwSixEEEEEEColor = Color(0xffEEEEEE);
  //纯DDDDDD
  static const Color zpwSixDDDDDDColor = Color(0xffDDDDDD);
  //默认黑色背景 1E
  static const Color zpwDefaultBackColor = Color(0xff1E1E1E);
  //nft progresscolor
  static const Color zpwNftProgressColor = Color(0xffFEB21F);
  //指示器颜色
  static const Color zpwNftIndictorColor = Color(0xffBCFA0E);

  //nft green 1 green 2渐变色
  static const Color zpwNftGreenColor1 = Color(0xffBCFA0E);
  static const Color zpwNftGreenColor2 = Color(0xff0EFAB3);

  //nft 橙色 渐变色
  static const Color zpwNftOrangeColor1 = ZpwColorPlate.zpwSixZeroColor;
  static const Color zpwNftOrangeColor2 = Color(0xffE07410);
//nft yellow
  static const Color zpwNftYellowColor = Color(0xffFFD90F);
  //nft origan color
  static const Color zpwNftOrangeColor3 = Color(0xffE07410);
  //红色
  static const Color zpwDefaultRed = Color(0xffFE1F1F);
  static const Color zpwDefaultGTRed = Color(0xffFE1F54);
  //进度条颜色
  static const Color zpwProgressbarColor = Color(0xff0EFAB3);
  //暗红色
  static const Color zpwDartRedColor = Color(0xffC72149);

  //9797A8
  static const Color zpwColor9797A8 = Color(0xff9797A8);
  //D8D8D8
  static const Color zpwColorD8D8D8 = Color(0xffD8D8D8);
  //EFFFFA
  static const Color zpwColorEFFFFA = Color(0xffEFFFFA);
  //2F2F51
  static const Color zpwColor2F2F51 = Color(0xff2F2F51);
  //182238
  static const Color zpwColor182238 = Color(0xff182238);
  static const Color zpwColor888D98 = Color(0xff888D98);
  static const Color zpwColorFF0000 = Color(0xffFF0000);

  // 兼容旧属性名的 getter
  static const Color themeColor = zpwThemeColor;
}

class ZpwTKFontWeight {
  static const FontWeight zpwMax9 = FontWeight.w900;
  static const FontWeight zpwMax8 = FontWeight.w800;
  static const FontWeight zpwMax7 = FontWeight.w700;
  static const FontWeight zpwMax6 = FontWeight.w600;
  static const FontWeight zpwMax5 = FontWeight.w500;
  static const FontWeight zpwMax4 = FontWeight.w400;
  static const FontWeight zpwNormal = FontWeight.normal;
  static const FontWeight zpwBold = FontWeight.bold;
}