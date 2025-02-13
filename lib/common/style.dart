import 'package:flutter/material.dart';

class SysSize {
  static const double avatar = 56;
  // static const double iconBig = 40;
  static const double iconNormal = 24;
  // static const double big = 18;
  // static const double normal = 16;
  // static const double small = 12;
  static const double iconBig = 40;
  static const double big = 16;
  static const double normal = 14;
  static const double small = 12;
}

class StandardTextStyle {
  static const TextStyle big = TextStyle(
    fontWeight: TKFontWeight.max6,
    fontSize: SysSize.big,
    inherit: true,
    color: Colors.grey,
  );
  static const TextStyle bigWithOpacity = TextStyle(
    color: Colors.white, //const Color.fromRGBO(0xff, 0xff, 0xff, .66),
    fontWeight: TKFontWeight.max6,
    fontSize: SysSize.big,
    inherit: true,
  );
  static const TextStyle normalW = TextStyle(
    fontWeight: TKFontWeight.max6,
    fontSize: SysSize.normal,
    inherit: true,
  );
  static const TextStyle normal = TextStyle(
    fontWeight: TKFontWeight.normal,
    fontSize: SysSize.normal,
    inherit: true,
  );
  static const TextStyle normalWithOpacity = TextStyle(
    color: Color.fromRGBO(0xff, 0xff, 0xff, .66),
    fontWeight: TKFontWeight.normal,
    fontSize: SysSize.normal,
    inherit: true,
  );
  static const TextStyle small = TextStyle(
    fontWeight: TKFontWeight.normal,
    fontSize: SysSize.small,
    inherit: true,
  );
  static const TextStyle smallWithOpacity = TextStyle(
    color: Color.fromRGBO(0xff, 0xff, 0xff, .66),
    fontWeight: TKFontWeight.normal,
    fontSize: SysSize.small,
    inherit: true,
  );
}

class ColorPlate {
  static const Color dot_red = Color(0xffFF5F00);
  static const Color dot_green = Color(0xff32CD98);

  // 配色
  static const Color orange = Color(0xffFFC459);
  static const Color yellow = Color(0xffF1E300);
  static const Color green = Color(0xff7ED321);
  static const Color red = Color(0xffEB3838);
  static const Color darkGray = Color(0xff4A4A4A);
  static const Color gray = Color(0xff9b9b9b);
  static const Color lightGray = Color(0xfff5f5f4);
  static const Color black = Color(0xff1E1E1E);
  static const Color white = Color(0xffffffff);
  static const Color clear = Color(0);
  static const Color defaultColor = Color(0xffCCCCCC);
  static const Color homeNameColor = Color(0xff666666);
  static const Color searchTextColor = Color(0xff999999);
  static const Color threeColor = Color(0xff333333);
  static const Color CommonGray = Color(0xffA2AAAE);
  static const Color CommonGreen = Color(0XFF36D58C);

  /// 页面背景色
  static const Color pageBgColor = Color(0xffF5F8FC);
  static const Color titleColor = Color(0xff191919);
  static const Color descColor = Color(0xff808080);
  static const Color scanDescColor = Color(0xff676767);

  /// 深色背景
  static const Color back1 = Color(0xff1D1F22);

  /// 比深色背景略深一点
  static const Color back2 = Color(0xff121314);

  static const Color defaultGreenColor = Color(0xffBCFA0E);
  //白色的40%透明度
  static Color ffffffOpacity4 = const Color(0xffFFFFFF).withOpacity(0.4);
  //白色的60%透明度
  static Color ffffffOpacity6 = const Color(0xffFFFFFF).withOpacity(0.6);
  //白色的20%透明度
  static Color ffffffOpacity2 = const Color(0xffFFFFFF).withOpacity(0.2);
  //纯白色
  static const Color fffffffOpacity1 = Color(0xffFFFFFF);
  //主题颜色
  static const Color themeColor = Color(0xffFF2D7D);
  static const Color tabbarThemeColor = Color(0xFF191919);
  // tabbar未选中时的文字颜色
  static const Color tabbarTextColorNormal = Color(0xffB3B3B3);
  // 主题背景颜色
  static const Color themeBgColor = Color(0xffF4F5F9);
  // 文字灰色
  static const Color commonGrayColor = Color(0xffB8B9BB);
  // 深灰色
  static const Color commonHighGrayColor = Color(0xff626A7B);

  //999999
  static const Color sixNineColor = Color(0xff4C4C4C);
  //66666
  static const Color sixSixColor = Color(0xff666666);
  //33333
  static const Color sixThreeColor = Color(0xff333333);
  //纯黑色 0000000
  static const Color sixZeroColor = Color(0xff000000);
  //纯黑色 1A
  static const Color sixZero1AColor = Color(0xff1A1A1A);
  //纯黑色 1111111
  static const Color sixZero1Color = Color(0xff111111);
  //纯黑色 22222222
  static const Color sixZero2Color = Color(0xff222222);
  //灰色 EEEEEE
  static const Color sixEEEEEEColor = Color(0xffEEEEEE);
  //纯DDDDDD
  static const Color sixDDDDDDColor = Color(0xffDDDDDD);
  //默认黑色背景 1E
  static const Color defaultBackColor = Color(0xff1E1E1E);
  //nft progresscolor
  static const Color nftProgressColor = Color(0xffFEB21F);
  //指示器颜色
  static const Color nftIndictorColor = Color(0xffBCFA0E);

  //nft green 1 green 2渐变色
  static const Color nftGreenColor1 = Color(0xffBCFA0E);
  static const Color nftGreenColor2 = Color(0xff0EFAB3);

  //nft 橙色 渐变色
  static const Color nftOrangeColor1 = ColorPlate.sixZeroColor;
  static const Color nftOrangeColor2 = Color(0xffE07410);
//nft yellow
  static const Color nftYellowColor = Color(0xffFFD90F);
  //nft origan color
  static const Color nftOrangeColor3 = Color(0xffE07410);
  //红色
  static const Color defaultRed = Color(0xffFE1F1F);
  static const Color defaultGTRed = Color(0xffFE1F54);
  //进度条颜色
  static const Color progressbarColor = Color(0xff0EFAB3);
  //暗红色
  static const Color dartRedColor = Color(0xffC72149);

  //9797A8
  static const Color color_9797A8 = Color(0xff9797A8);
  //D8D8D8
  static const Color color_D8D8D8 = Color(0xffD8D8D8);
  //EFFFFA
  static const Color color_EFFFFA = Color(0xffEFFFFA);
  //2F2F51
  static const Color color_2F2F51 = Color(0xff2F2F51);
  //182238
  static const Color color_182238 = Color(0xff182238);
  static const Color color_888D98 = Color(0xff888D98);
  static const Color color_FF0000 = Color(0xffFF0000);
}

class TKFontWeight {
  static const FontWeight max9 = FontWeight.w900;
  static const FontWeight max8 = FontWeight.w800;
  static const FontWeight max7 = FontWeight.w700;
  static const FontWeight max6 = FontWeight.w600;
  static const FontWeight max5 = FontWeight.w500;
  static const FontWeight max4 = FontWeight.w400;
  static const FontWeight normal = FontWeight.normal;
  static const FontWeight bold = FontWeight.bold;
}
