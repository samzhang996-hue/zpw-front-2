import 'package:flutter/cupertino.dart';
import 'package:flutter_pangle_ads/flutter_pangle_ads.dart';
import 'package:get/get.dart';
import 'package:zpw/common/zpw_ads_config.dart';
import 'package:zpw/modules/main/zpw_main_page.dart';
import 'package:zpw/utils/zpw_log_utils.dart';


class ZpwAdsUtils {
  /// 初始化广告 SDK
  static Future<bool> init() async {
    bool result = await FlutterPangleAds.initAd(
      ZpwAdsConfig.appId,
      directDownloadNetworkType: [
        NetworkType.kNetworkStateMobile,
        NetworkType.kNetworkStateWifi,
      ],
    );
    debugPrint("广告SDK 初始化${result ? '成功' : '失败'}");

    // 打开个性化广告推荐
    FlutterPangleAds.setUserExtData(personalAdsType: '1');
    return result;
  }

  /// 设置广告监听
  static Future<void> setAdEvent() async {
    FlutterPangleAds.onEventListener((event) {
      ZpwLog.d("event---${event.action}--${event.adId}");
      print("event---${event.action}--${event.adId}");
      if (event is AdErrorEvent) {
        ZpwLog.d(
            "${event.adId}--errCode:${event.errCode}---errMsg:${event.errMsg}");
      }

      ///Splash
      if (event.adId == ZpwAdsConfig.splashId) {
        if (event.action == AdEventAction.onAdError ||
            event.action == AdEventAction.onAdLoaded) {
          Get.offAll(const ZpwMainPage());
        }
      }

      ///banner
      if (event.adId == ZpwAdsConfig.bannerId) {
        // final logic = Get.find<ZpwMineLogic>();
        // if (event.action == AdEventAction.onAdLoaded) {
        //   logic.onShowView(true);
        // } else if (event.action == AdEventAction.onAdClosed ||
        //     event.action == AdEventAction.onAdError) {
        //   logic.onShowView(false);
        // }
      }

      ///banner2
      if (event.adId == ZpwAdsConfig.bannerId2) {
        // final logic = Get.find<SettingsLogic>();
        // if (event.action == AdEventAction.onAdLoaded) {
        //   logic.onShowBanner(true);
        // } else if (event.action == AdEventAction.onAdClosed ||
        //     event.action == AdEventAction.onAdError) {
        //   logic.onShowBanner(false);
        // }
      }

      ///banner3
      if (event.adId == ZpwAdsConfig.bannerId3) {
        // final logic = Get.find<Customer_serviceLogic>();
        // if (event.action == AdEventAction.onAdLoaded) {
        //   logic.onShowBanner3(true);
        // } else if (event.action == AdEventAction.onAdClosed ||
        //     event.action == AdEventAction.onAdError) {
        //   logic.onShowBanner3(false);
        // }
      }
    });
  }

  /// 展示开屏广告
  /// [logo] 展示如果传递则展示logo，不传递不展示
  static Future<void> showSplashAd([String? logo]) async {
    bool result = await FlutterPangleAds.showSplashAd(
      ZpwAdsConfig.splashId,
      logo: logo,
      timeout: 3.5,
    );
    ZpwLog.i("展示开屏广告${result ? '成功' : '失败'}");
  }

  /// 展示全屏视频、新插屏广告
  /// [posId] 广告位id
  Future<void> showFullScreenVideoAd(String posId) async {
    bool result = await FlutterPangleAds.showFullScreenVideoAd(posId);
    print("展示插屏广告${result ? '成功' : '失败'}");
  }
}