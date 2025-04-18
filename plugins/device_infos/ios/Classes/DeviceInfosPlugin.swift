import Flutter
import AdSupport
import UIKit
import AppTrackingTransparency

public class DeviceInfosPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.muka.device_infos", binaryMessenger: registrar.messenger())
    let instance = DeviceInfosPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getIDFV":
      getIDFV(result);
      break;
    case "getIDFA":
      getIDFA(result)
      break;
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  func getIDFV(_ result: FlutterResult) {
    let idfv = UIDevice.current.identifierForVendor?.uuidString
    result(idfv) // 返回 IDFV
  }
    func getIDFA(_ result: @escaping FlutterResult) {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { [resultCopy = result] status in
                if status == ATTrackingManager.AuthorizationStatus.authorized {
                    let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                    resultCopy(idfa)
                } else {
                    print("请在设置-隐私-跟踪中允许App请求跟踪")
                    resultCopy(FlutterError(code: "UNAUTHORIZED", message: "User denied tracking authorization", details: nil))
                }
            })
        } else {
            let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            result(idfa)
        }
    }
}
