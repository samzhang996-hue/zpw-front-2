import 'dart:io';

/// 广告配置信息
class ZpwAdsConfig {
  static String zpwAdSplash =
      'https://engine.tuifish.com/index/activity?appKey=2TZu97Q5mKBP4FLf27NxNTgJgWse&adslotId=465985';
  static String zpwAdBanner =
      'https://engine.tuifish.com/index/activity?appKey=2TZu97Q5mKBP4FLf27NxNTgJgWse&adslotId=465986';
  static String zpwAdDialog =
      'https://engine.tuifish.com/index/activity?appKey=2TZu97Q5mKBP4FLf27NxNTgJgWse&adslotId=465202';
  static String zpwAdIcon =
      'https://engine.tuifish.com/index/activity?appKey=2TZu97Q5mKBP4FLf27NxNTgJgWse&adslotId=465203';
  static String zpwAdXf =
      'https://engine.tuifish.com/index/activity?appKey=2TZu97Q5mKBP4FLf27NxNTgJgWse&adslotId=465987';

  /// 获取 Logo 资源名称
  static String get zpwLogo {
    if (Platform.isAndroid) {
      return 'flutterads_logo';
    } else {
      return 'LaunchImage';
    }
  }

  /// 获取 Logo 资源名称 2
  static String get zpwLogo2 {
    if (Platform.isAndroid) {
      return 'flutterads_logo2';
    } else {
      return 'LaunchImage2';
    }
  }

  /// 获取 App id
  static String get zpwAppId => Platform.isAndroid ? '5405335' : '5656226';

  /// 获取开屏广告位id
  static String get zpwSplashId => Platform.isAndroid ? '888346746' : '890746830';

  /// 获取 Banner 广告位id
  static String get zpwBannerId => Platform.isAndroid ? '952707241' : '963568919';
  static String get zpwBannerId2 => Platform.isAndroid ? '960813252' : '963568924';
  static String get zpwBannerId3 => Platform.isAndroid ? '960813253' : '963568928';

  /// 获取 Feed 信息流广告位id(左右图文 2.4)
  static String get zpwFeedId => Platform.isAndroid ? '952707240' : '963568849';

  /// 获取激励视频广告位id
  static String get zpwRewardVideoId =>
      Platform.isAndroid ? '952707246' : '963568814';

  /// 获取新插屏广告位id
  static String get zpwNewInterstitialId =>
      Platform.isAndroid ? '952707243' : '963568829';

  // 兼容旧属性名的 getter
  static String get bannerId => zpwBannerId;
  static String get bannerId2 => zpwBannerId2;
  static String get bannerId3 => zpwBannerId3;
  static String get appId => zpwAppId;
  static String get splashId => zpwSplashId;
}