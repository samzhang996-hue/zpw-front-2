import 'dart:io';

/// 广告配置信息
class AdsConfig {
  static String adSplash =
      'https://engine13.gdbtui9.cn/index/activity?appKey=2TZu97Q5mKBP4FLf27NxNTgJgWse&adslotId=465985&uk_a1=__IMEI__&uk_a2=__IMEI2__&uk_a3=__MUID__&uk_b1=__IDFA__&uk_b2=__IDFA2__&uk_c1=__OAID__&uk_c2=__OAID2__';
  static String adBanner =
      'https://engine13.gdbtui9.cn/index/activity?appKey=2TZu97Q5mKBP4FLf27NxNTgJgWse&adslotId=465986&uk_a1=__IMEI__&uk_a2=__IMEI2__&uk_a3=__MUID__&uk_b1=__IDFA__&uk_b2=__IDFA2__&uk_c1=__OAID__&uk_c2=__OAID2__';
  static String adDialog =
      'https://engine13.gdbtui9.cn/index/activity?appKey=2TZu97Q5mKBP4FLf27NxNTgJgWse&adslotId=465202&uk_a1=__IMEI__&uk_a2=__IMEI2__&uk_a3=__MUID__&uk_b1=__IDFA__&uk_b2=__IDFA2__&uk_c1=__OAID__&uk_c2=__OAID2__';
  static String adIcon =
      'https://engine13.gdbtui9.cn/index/activity?appKey=2TZu97Q5mKBP4FLf27NxNTgJgWse&adslotId=465203&uk_a1=__IMEI__&uk_a2=__IMEI2__&uk_a3=__MUID__&uk_b1=__IDFA__&uk_b2=__IDFA2__&uk_c1=__OAID__&uk_c2=__OAID2__';
  static String adXf =
      'https://engine13.gdbtui9.cn/index/activity?appKey=2TZu97Q5mKBP4FLf27NxNTgJgWse&adslotId=465987&uk_a1=__IMEI__&uk_a2=__IMEI2__&uk_a3=__MUID__&uk_b1=__IDFA__&uk_b2=__IDFA2__&uk_c1=__OAID__&uk_c2=__OAID2__';

  /// 获取 Logo 资源名称
  static String get logo {
    if (Platform.isAndroid) {
      return 'flutterads_logo';
    } else {
      return 'LaunchImage';
    }
  }

  /// 获取 Logo 资源名称 2
  static String get logo2 {
    if (Platform.isAndroid) {
      return 'flutterads_logo2';
    } else {
      return 'LaunchImage2';
    }
  }

  /// 获取 App id
  static String get appId => Platform.isAndroid ? '5405335' : '5656226';

  /// 获取开屏广告位id
  static String get splashId => Platform.isAndroid ? '888346746' : '890746830';

  /// 获取 Banner 广告位id
  static String get bannerId => Platform.isAndroid ? '952707241' : '963568919';
  static String get bannerId2 => Platform.isAndroid ? '960813252' : '963568924';
  static String get bannerId3 => Platform.isAndroid ? '960813253' : '963568928';

  /// 获取 Feed 信息流广告位id(左右图文 2.4)
  static String get feedId => Platform.isAndroid ? '952707240' : '963568849';

  /// 获取激励视频广告位id
  static String get rewardVideoId =>
      Platform.isAndroid ? '952707246' : '963568814';

  /// 获取新插屏广告位id
  static String get newInterstitialId =>
      Platform.isAndroid ? '952707243' : '963568829';
}
