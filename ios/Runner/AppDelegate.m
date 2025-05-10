#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import "BDASignalManager.h"
#import "BDASignalDefinitions.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/ASIdentifierManager.h>
#import <UIKit/UIKit.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
    
  // Get the Flutter view controller and create a method channel
  FlutterViewController *controller = (FlutterViewController *)self.window.rootViewController;
  FlutterMethodChannel *methodChannel = [FlutterMethodChannel methodChannelWithName:@"MyPlugin"
                                                                   binaryMessenger:controller.binaryMessenger];

  // Handle method calls from Flutter
  [methodChannel setMethodCallHandler:^(FlutterMethodCall *call, FlutterResult result) {
    if ([call.method isEqualToString:@"getChannelInfo"]) {
           result(@"AIIOS");
//      NSDictionary *args = call.arguments;
//      NSNumber *type = args[@"type"];
//      
//      if (type) {
//        if ([type isEqualToNumber:@1]) {
//          result(@"");
//        } else if ([type isEqualToNumber:@2]) {
//          result(@"30");
//        } else if ([type isEqualToNumber:@3]) {
//          result(@"AIIOS");
//        } else {
//          result([FlutterError errorWithCode:@"INVALID_ARGUMENT"
//                                     message:@"Invalid argument"
//                                     details:nil]);
//        }
//      } else {
//        result([FlutterError errorWithCode:@"INVALID_ARGUMENT"
//                                   message:@"Argument missing"
//                                   details:nil]);
//      }
    }
    else  if ([call.method isEqualToString:@"RangerInit"]) {
        [self rangerInit:launchOptions];
    }
    else  if ([call.method isEqualToString:@"projectId"]) {
        result(@"30");
    }
      else if([call.method isEqualToString:@"getIDFA"]) {
       [self getIDFAWithResult:result];
      }
      else if([call.method isEqualToString:@"getIDFV"]) {
       [self getIDFVWithResult:result];
      }
    else {
      result(FlutterMethodNotImplemented);
    }
  }];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    // 将url参数转换成string类型之后，传递给SDK
    NSString *openUrl = url.absoluteString;
    [BDASignalManager anylyseDeeplinkClickidWithOpenUrl:openUrl];
    return YES;
}

- (void) rangerInit:(NSDictionary *)launchOptions {
    // 注册可选参数
    [BDASignalManager registerWithOptionalData:@{
        kBDADSignalSDKUserUniqueId : @""  // 业务用户id，非必传
    }];
    // 上报冷启动事件
    [BDASignalManager didFinishLaunchingWithOptions:launchOptions connectOptions:nil];
    [BDASignalManager enableIdfa:YES];
    BOOL isok  = [BDASignalManager getIdfaStatus];
}

- (void)getIDFVWithResult:(FlutterResult)result {
NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
   result(idfv);  // 返回 IDFV
}

- (void)getIDFAWithResult:(FlutterResult)result {
    
  if (@available(iOS 14, *)) {
      
      [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
             // 获取到权限后，依然使用老方法获取idfa
             if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                 NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
                 result(idfa);  // 返回 IDFA
             } else {
                      NSLog(@"请在设置-隐私-跟踪中允许App请求跟踪");
                 result([FlutterError errorWithCode:@"UNAUTHORIZED" message:@"User denied tracking authorization" details:nil]);
             }
         }];


 
    
  } else {
    // iOS 14 以下版本直接获取 IDFA
    NSString *idfa = [[ASIdentifierManager sharedManager] advertisingIdentifier].UUIDString;
    result(idfa);  // 返回 IDFA
  }
}

@end
