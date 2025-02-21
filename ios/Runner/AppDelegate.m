#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"

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
    
    else  if ([call.method isEqualToString:@"projectId"]) {
        result(@"30");
    }
      
    else {
      result(FlutterMethodNotImplemented);
    }
  }];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
