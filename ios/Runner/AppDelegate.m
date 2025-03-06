#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import "BDASignalManager.h"
#import "BDASignalDefinitions.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
    
    
    // 注册可选参数
    [BDASignalManager registerWithOptionalData:@{
        kBDADSignalSDKUserUniqueId : @""  // 业务用户id，非必传
    }];
    // 上报冷启动事件
    [BDASignalManager didFinishLaunchingWithOptions:launchOptions connectOptions:nil];
    [BDASignalManager enableIdfa:YES];
    
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
    
    else  if ([call.method isEqualToString:@"projectId"]) {
        result(@"30");
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

@end
