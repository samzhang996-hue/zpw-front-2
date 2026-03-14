#import "ZpwAppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import "BDASignalManager.h"
#import "BDASignalDefinitions.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/ASIdentifierManager.h>
#import <UIKit/UIKit.h>

@implementation ZpwAppDelegate

- (BOOL)application:(UIApplication *)zpwApplication
    didFinishLaunchingWithOptions:(NSDictionary *)zpwLaunchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];


    // 注册可选参数
    [BDASignalManager registerWithOptionalData:@{
        kBDADSignalSDKUserUniqueId : @""  // 业务用户id，非必传
    }];
    // 上报冷启动事件
    [BDASignalManager didFinishLaunchingWithOptions:zpwLaunchOptions connectOptions:nil];
    [BDASignalManager enableIdfa:YES];
    BOOL zpwIdfaOk  = [BDASignalManager getIdfaStatus];

  // Get the Flutter view controller and create a method channel
  FlutterViewController *zpwController = (FlutterViewController *)self.window.rootViewController;
  FlutterMethodChannel *zpwMethodChannel = [FlutterMethodChannel methodChannelWithName:@"zpw_plugin"
                                                                   binaryMessenger:zpwController.binaryMessenger];

  // Handle method calls from Flutter
  [zpwMethodChannel setMethodCallHandler:^(FlutterMethodCall *zpwCall, FlutterResult zpwResult) {
    if ([zpwCall.method isEqualToString:@"getChannelInfo"]) {
           zpwResult(@"AIIOS");
    }

    else  if ([zpwCall.method isEqualToString:@"projectId"]) {
        zpwResult(@"30");
    }
      else if([zpwCall.method isEqualToString:@"getIDFA"]) {
       [self zpwGetIDFAWithResult:zpwResult];
      }
      else if([zpwCall.method isEqualToString:@"getIDFV"]) {
       [self zpwGetIDFVWithResult:zpwResult];
      }
    else {
      zpwResult(FlutterMethodNotImplemented);
    }
  }];
  return [super application:zpwApplication didFinishLaunchingWithOptions:zpwLaunchOptions];
}


- (BOOL)application:(UIApplication *)zpwApp openURL:(NSURL *)zpwUrl options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)zpwOptions {
    // 将url参数转换成string类型之后，传递给SDK
    NSString *zpwOpenUrl = zpwUrl.absoluteString;
    [BDASignalManager anylyseDeeplinkClickidWithOpenUrl:zpwOpenUrl];
    return YES;
}

- (void)zpwGetIDFVWithResult:(FlutterResult)zpwResult {
NSString *zpwIdfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
   zpwResult(zpwIdfv);  // 返回 IDFV
}

- (void)zpwGetIDFAWithResult:(FlutterResult)zpwResult {

  if (@available(iOS 14, *)) {

      [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus zpwStatus) {
             // 获取到权限后，依然使用老方法获取idfa
             if (zpwStatus == ATTrackingManagerAuthorizationStatusAuthorized) {
                 NSString *zpwIdfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
                 zpwResult(zpwIdfa);  // 返回 IDFA
             } else {
                      NSLog(@"请在设置-隐私-跟踪中允许App请求跟踪");
                 zpwResult([FlutterError errorWithCode:@"UNAUTHORIZED" message:@"User denied tracking authorization" details:nil]);
             }
         }];



  } else {
    // iOS 14 以下版本直接获取 IDFA
    NSString *zpwIdfa = [[ASIdentifierManager sharedManager] advertisingIdentifier].UUIDString;
    zpwResult(zpwIdfa);  // 返回 IDFA
  }
}

@end