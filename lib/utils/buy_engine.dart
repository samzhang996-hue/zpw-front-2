import 'dart:async';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:zpw/modules/vip/vip_logic.dart';
import 'package:zpw/utils/handle_tool.dart';
import 'package:zpw/utils/log_utils.dart';

class BuyEngin {
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  late InAppPurchase _inAppPurchase;
  late List<ProductDetails> _products; //内购的商品对象集合
  late bool isPay = true;

  final bool showTips;

  BuyEngin({this.showTips = true});
  //初始化购买组件
  void initializeInAppPurchase() {
    // 初始化in_app_purchase插件
    _inAppPurchase = InAppPurchase.instance;

    //监听购买的事件
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      EasyLoading.dismiss();
      error.printError();
    });
  }

  Future<void> resumePurchase() async {
    isPay = false;
    EasyLoading.show();
    final bool available = await _inAppPurchase.isAvailable();
    if (!available) {
      if (showTips) {
        HandleTool.showAppToastText("无法连接到商店");
      }

      EasyLoading.dismiss();
      return;
    }
    try {
      _inAppPurchase.restorePurchases();
    } catch (e) {
      EasyLoading.dismiss();
      Log.d("$e");
    }
  }

  Future<void> clearPendingPurchases() async {
    if (Platform.isIOS) {
      try {
        final transactions = await SKPaymentQueueWrapper().transactions();
        for (final transaction in transactions) {
          try {
            await SKPaymentQueueWrapper().finishTransaction(transaction);
          } catch (e) {
            EasyLoading.dismiss();
            rethrow;
          }
        }
      } catch (e) {
        EasyLoading.dismiss();
        rethrow;
      }
    }
  }

  /// 加载全部的商品
  void buyProduct(String productId) async {
    await clearPendingPurchases();
    isPay = true;
    EasyLoading.show();
    print("请求商品id___:" + productId);
    // if (Platform.isIOS) {
    //   final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
    //   _inAppPurchase
    //       .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
    //   await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    // }
    List<String> _outProducts = [productId];

    final bool available = await _inAppPurchase.isAvailable();
    if (!available) {
      if (showTips) {
        HandleTool.showAppToastText("无法连接到商店");
      }

      EasyLoading.dismiss();
      print("无法连接到商店");
      return;
    }

    //开始购买
    // ToastUtil.showToast("连接成功-开始查询全部商品");
    print("连接成功-开始查询全部商品");
    List<String> _kIds = _outProducts;

    final ProductDetailsResponse response =
        await _inAppPurchase.queryProductDetails(_kIds.toSet());
    // AppStoreProductDetails productDetails = response.productDetails as AppStoreProductDetails;
    // print("商品获取结果  " + productDetails.toString());
    if (response.notFoundIDs.isNotEmpty) {
      EasyLoading.dismiss();
      if (showTips) {
        HandleTool.showAppToastText("未查询到商品订单");
      }
      //
      // print("无法找到指定的商品");
      // ToastUtil.showToast("无法找到指定的商品 数量 " + response.productDetails.length.toString());

      return;
    }

    // 处理查询到的商品列表
    List<ProductDetails> products = response.productDetails;
    print("products ==== " + products.length.toString());
    if (products.isNotEmpty) {
      //赋值内购商品集合
      _products = products;
    }

    // print("全部商品加载完成了，可以启动购买了,总共商品数量为：${products.length}");

    //先恢复可重复购买
    // await _inAppPurchase. ();

    startPurchase(productId);
  }

  // 调用此函数以启动购买过程
  void startPurchase(String productId) async {
    // print("购买的商品id为" + productId);
    if (_products != null && _products.isNotEmpty) {
      // ToastUtil.showToast("准备开始启动购买流程");
      try {
        ProductDetails productDetails = _getProduct(productId);
        // print(
        //     "一切正常，开始购买,信息如下：title: ${productDetails.title}  desc:${productDetails.description} "
        //     "price:${productDetails.price}  currencyCode:${productDetails.currencyCode}  currencySymbol:${productDetails.currencySymbol}");
        _inAppPurchase.buyConsumable(
            purchaseParam: PurchaseParam(productDetails: productDetails));
      } catch (e) {
        EasyLoading.dismiss();
        // print("购买失败了");
      }
    } else {
      EasyLoading.dismiss();
      // print("当前没有商品无法调用购买逻辑");
    }
  }

  // 根据产品ID获取产品信息
  ProductDetails _getProduct(String productId) {
    return _products.firstWhere((product) => product.id == productId);
  }

  String id = "";
  String reData = "";

  /// 内购的购买更新监听
  void _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    if (purchaseDetailsList.isEmpty) {
      EasyLoading.dismiss();
      if (showTips) {
        HandleTool.showAppToastText("未查询到商品订单");
      }
      // HandleTool.showAppToastText("未查询到商品订单");
      return;
    }
    Log.d("sta----0000----${purchaseDetailsList.length}");
    final logic = Get.put(VipLogic());
    for (PurchaseDetails purchase in purchaseDetailsList) {
      var appstoreDetail = purchase as AppStorePurchaseDetails;
      // Log.d("sta----0000---id:${appstoreDetail.purchaseID}");
      if (purchase.status == PurchaseStatus.pending) {
        // 等待支付完成
        _handlePending();
      } else if (purchase.status == PurchaseStatus.canceled) {
        EasyLoading.dismiss();
        // 取消支付
        _handleCancel(purchase);
      } else if (purchase.status == PurchaseStatus.error) {
        EasyLoading.dismiss();
        // 购买失败
        var error = purchase.error;
        _handleError(error!);
      } else if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        EasyLoading.dismiss();
        //完成购买, 到服务器验证
        if (Platform.isAndroid) {
          var googleDetail = purchase as GooglePlayPurchaseDetails;
          // checkAndroidPayInfo(googleDetail);
        } else if (Platform.isIOS) {
          var appstoreDetail = purchase as AppStorePurchaseDetails;
          Log.d("sta----rl--${purchase.pendingCompletePurchase}");
          if (!("${appstoreDetail.purchaseID}" == id &&
              reData ==
                  appstoreDetail.verificationData.serverVerificationData)) {
            if (isPay == false) {
              logic.restoreIosPay(
                  appstoreDetail.verificationData.serverVerificationData,
                  "${appstoreDetail.purchaseID}");
              id = "${appstoreDetail.purchaseID}";
              reData = appstoreDetail.verificationData.serverVerificationData;
              if (purchase.pendingCompletePurchase) {
                checkApplePayInfo(appstoreDetail);
              }
              break;
            } else {
              logic.iosPay(
                  appstoreDetail.verificationData.serverVerificationData,
                  "${appstoreDetail.purchaseID}");
            }
          }
          id = "${appstoreDetail.purchaseID}";
          reData = appstoreDetail.verificationData.serverVerificationData;
          if (purchase.pendingCompletePurchase) {
            checkApplePayInfo(appstoreDetail);
          }
        }
      }
    }
  }

  /// 购买失败
  void _handleError(IAPError iapError) {
    // ToastUtil.showToast("${DataConfig.getShowName("Purchase_Failed")}：${iapError?.code} message${iapError?.message}");
  }

  /// 等待支付
  void _handlePending() {
    print("等待支付");
  }

  /// 取消支付
  void _handleCancel(PurchaseDetails purchase) {
    _inAppPurchase.completePurchase(purchase);
  }

  /// Android支付成功的校验
  void checkAndroidPayInfo(GooglePlayPurchaseDetails googleDetail) async {
    _inAppPurchase.completePurchase(googleDetail);
    print("安卓支付交易ID为${googleDetail.purchaseID}");
    print("安卓支付验证收据为" + googleDetail.verificationData.serverVerificationData);
  }

  /// Apple支付成功的校验
  void checkApplePayInfo(AppStorePurchaseDetails appstoreDetail) async {
    _inAppPurchase.completePurchase(appstoreDetail);

    /// 完成支付
    print("Apple支付交易ID为${appstoreDetail.purchaseID}");
    print("Apple支付验证收据为" +
        appstoreDetail.verificationData.serverVerificationData);
  }

  void onCloseIos() {
    EasyLoading.dismiss();
    Log.d("close----");
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    _subscription.cancel();
  }
}
// class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
//   @override
//   bool shouldContinueTransaction(
//       SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
//     return true;
//   }
//
//   @override
//   bool shouldShowPriceConsent() {
//     return false;
//   }
// }
