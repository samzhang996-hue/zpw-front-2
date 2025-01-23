import 'dart:io';

/// 广告配置信息
class AdsConfig {
  static String adSplash =
      'https://engine.tuifish.com/index/activity?appKey=2TZu97Q5mKBP4FLf27NxNTgJgWse&adslotId=465985';
  static String adBanner =
      'https://engine.tuifish.com/index/activity?appKey=2TZu97Q5mKBP4FLf27NxNTgJgWse&adslotId=465986';
  static String adDialog =
      'https://engine.tuifish.com/index/activity?appKey=2TZu97Q5mKBP4FLf27NxNTgJgWse&adslotId=465202';
  static String adIcon =
      'https://engine.tuifish.com/index/activity?appKey=2TZu97Q5mKBP4FLf27NxNTgJgWse&adslotId=465203';
  static String adXf =
      'https://engine.tuifish.com/index/activity?appKey=2TZu97Q5mKBP4FLf27NxNTgJgWse&adslotId=465987';

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
