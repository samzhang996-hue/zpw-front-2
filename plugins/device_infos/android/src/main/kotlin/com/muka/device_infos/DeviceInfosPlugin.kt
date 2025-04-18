package com.muka.device_infos



import android.Manifest
import android.annotation.SuppressLint
import android.app.Activity
import android.app.ActivityManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.provider.Settings.Secure
import android.telephony.TelephonyManager
import android.text.TextUtils
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.blankj.utilcode.util.ActivityUtils
import com.blankj.utilcode.util.DeviceUtils
import com.blankj.utilcode.util.SPUtils
import com.meituan.android.walle.WalleChannelReader
import com.umeng.commonsdk.UMConfigure
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.*
import java.net.URLEncoder
import android.provider.Settings;
// import com.mobile.auth.gatewayauth.TokenResultListener
// import com.mobile.auth.gatewayauth.model.TokenRet
// import com.mobile.auth.gatewayauth.PhoneNumberAuthHelper;
// import com.mobile.auth.gatewayauth.PreLoginResultListener;
// import com.mobile.auth.gatewayauth.ResultCode
// import io.flutter.plugin.common.FlutterException

/** DeviceInfosPlugin */
class DeviceInfosPlugin : FlutterPlugin, ActivityAware, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    private lateinit var mContext: Context

    private var mActivity: Activity? = null

    private val PERMISSION_REQUEST_CODE = 1

    private var pendingResult: MethodChannel.Result? = null

    // private var mAuthHelper: PhoneNumberAuthHelper? = null

    // private var mTokenResultListener: TokenResultListener? = null


    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        mContext = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.muka.device_infos")
        channel.setMethodCallHandler(this)
    }

    @SuppressLint("HardwareIds")
    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getDeviceId" -> {
                result.success(DeviceUtils.getUniqueDeviceId());
            }

            "getAndroidID" -> {
                result.success(Settings.Secure.getString(mContext.contentResolver, Settings.Secure.ANDROID_ID));
            }

            "getIMEI" -> {
                var imei = ""

                val telephonyManager = mContext.getSystemService(Context.TELEPHONY_SERVICE) as? TelephonyManager
               try{
                   if (telephonyManager != null) {
                       // 权限检查
                       if (ActivityCompat.checkSelfPermission(mContext, Manifest.permission.READ_PHONE_STATE) != PackageManager.PERMISSION_GRANTED) {
                           result.success("");
                           return
                       }

                       // 根据不同的 Android 版本来获取 IMEI
                       imei = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                           // Android 8.0及以上使用getImei()
                           telephonyManager.imei ?: ""
                       } else {
                           // Android 8.0以下使用getDeviceId()
                           telephonyManager.deviceId ?: ""
                       }
                   }
               }catch (e:Exception){
                   imei = ""
               }

                result.success(imei);
            }

            "getMEID" -> {
                result.success(Secure.getString(mContext.contentResolver, Secure.ANDROID_ID));
            }

            "getUA" -> {
                result.success(System.getProperty("http.agent"));
            }

            "onDownloadFile" -> {
                val url = call.argument<String>("url")
                val uri = Uri.parse(url)
                val downloadIntent = Intent(Intent.ACTION_VIEW, uri)
                mContext.startActivity(downloadIntent)
            }

            "projectId" -> {
                var projectId2 = WalleChannelReader.get(mContext, "projectId")
                projectId2 = if (TextUtils.isEmpty(projectId2)) "33" else projectId2
                result.success(projectId2);
            }

            "boost" -> {
                handleBoostRequest(result)
            }

            "getChannelInfo" -> {
                handleGetChannelInfo(call, result)
            }

            "getOAID" -> {
                UMConfigure.getOaid(
                    mContext
                ) { s -> result.success(if (TextUtils.isEmpty(s)) "" else s) }

            }

            "setOrderZfb" -> {
                val url = call.argument<String>("message")
                val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
                mContext.startActivity(intent)
            }

            "htmlFlutter" -> {
                val appId = call.argument<String>("appId")
                val jumpUrl = call.argument<String>("jumpUrl")
                val outTradeNo = call.argument<String>("outTradeNo")
                start(
                    appId,
                    "$jumpUrl?",
                    "out_trade_no=$outTradeNo"
                )
            }

            "xcsFlutter" -> {
                val channel2 =
                    if (TextUtils.isEmpty(WalleChannelReader.getChannel(mContext))) "YYJL001" else WalleChannelReader.getChannel(
                        mContext
                    )!!
                val projectId2 = if (TextUtils.isEmpty(
                        WalleChannelReader.get(
                            mContext,
                            "projectId"
                        )
                    )
                ) "19" else WalleChannelReader.get(mContext, "projectId")!!
                val userId: Int = call.argument("userId")!!
                val goodsId: Int = call.argument("goodsId")!!
                start2("userId=$userId&goodsId=$goodsId&projectId=$projectId2&channel=$channel2")
            }

            "onH5" -> {
                val h5url :String = call.argument ("url")!!;

                val intent1:Intent  = Intent(mContext, CommActivity::class.java)
                intent1.putExtra("zfbUrl", h5url);
                ActivityUtils.startActivity(intent1);
            }
            // "aliAuthInit" -> {
            //     sdkInit(call,result)
            //     numberAuth(5000);
            // }
            // "getOperator" -> {
            //     getOperator(call,result)
            // }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    /**
     * 支付宝小程序
     *
     * @param context 上下文处理
     * @param appId   小程序appId
     * @param page    小程序跳转的页面。如果不设置，默认为跳转至首页。例如：pages/user/user
     * @param query   启动参数，内容按照格式为参数名=参数值&参数名=参数值…之后encode，例如：client_type=2
     */
    fun start2(query: String?) {
        try {
            val sb = StringBuffer("alipays://platformapi/startapp?")
            val link = URLEncoder.encode(query, "UTF-8")
            sb.append("appId=").append("2021004160634906").append("&")
            sb.append("page=").append("pages/new/new?").append(link)
            val uri = Uri.parse(sb.toString())
            val intent = Intent(Intent.ACTION_VIEW, uri)
            mContext.startActivity(intent)
        } catch (e: java.lang.Exception) {
            e.printStackTrace()
        }
    }

    /**
     * 支付宝小程序
     *
     * @param context 上下文处理
     * @param appId   小程序appId
     * @param page    小程序跳转的页面。如果不设置，默认为跳转至首页。例如：pages/user/user
     * @param query   启动参数，内容按照格式为参数名=参数值&参数名=参数值…之后encode，例如：client_type=2
     */
    fun start(appId: String?, page: String?, query: String?) {
        try {
            val sb = StringBuffer("alipays://platformapi/startapp?")
            val link = URLEncoder.encode(query, "UTF-8")
            sb.append("appId=").append(appId).append("&")
            sb.append("page=").append(page).append(link)
            //            sb.append("page=").append(page).append("&");
//            sb.append("query=").append(link);
            val uri = Uri.parse(sb.toString())
            val intent = Intent(Intent.ACTION_VIEW, uri)
            mContext.startActivity(intent)
        } catch (e: java.lang.Exception) {
            e.printStackTrace()
        }
    }

    private fun handleGetChannelInfo(call: MethodCall, result: MethodChannel.Result) {
        val type = call.argument<Int>("type")
        val channelInfo = WalleChannelReader.getChannelInfo(mContext)
        val channel = WalleChannelReader.getChannel(mContext)
        val uid = WalleChannelReader.get(mContext, "uid")
        val projectId = WalleChannelReader.get(mContext, "projectId")
        val key = when (type) {
            1 -> uid
            2 -> if (projectId.isNullOrEmpty()) "33" else projectId
            else -> if (channel.isNullOrEmpty()) "YMGCJL001" else channel
        }
        result.success(if (key.isNullOrEmpty()) "" else key);
    }

    /**
     * 获取设备信息
     *
     * @return
     */
    fun getDeviceInfo(): Any {
        val deviceInfo: DeviceInfo = DeviceInfo()
        val oaid = SPUtils.getInstance().getString("oaid")
        deviceInfo.setDeviceId(DeviceUtils.getUniqueDeviceId())
        deviceInfo.setModelInfo(DeviceUtils.getModel())
        deviceInfo.setSystemInfo(DeviceUtils.getSDKVersionName())
        deviceInfo.setSystemDevice("android")
        deviceInfo.setOaid(oaid)
        deviceInfo.setRoot(DeviceUtils.isDeviceRooted())
        deviceInfo.setImei(getIMEI(mContext.applicationContext))
        deviceInfo.setABIs(DeviceUtils.getABIs())
//        deviceInfo.setMac(DeviceUtils.getMacAddress())
        deviceInfo.setAndroidId(DeviceUtils.getAndroidID())
        deviceInfo.setSDKVersionCode(DeviceUtils.getSDKVersionCode())
        deviceInfo.setEmulator(DeviceUtils.isEmulator())
        deviceInfo.setTablet(DeviceUtils.isTablet())
        //        deviceInfo.setSameDevice(DeviceUtils.isSameDevice(oaid));
        deviceInfo.setManufacturer(DeviceUtils.getManufacturer())
        return deviceInfo
    }

    fun getIMEI(context: Context): String? {
        val telephonyManager = context.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
        if (telephonyManager != null) {
            return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                // 在 Android O 及以上版本中，需要使用 getImei() 方法获取 IMEI 号码
                ""
            } else {
                // 在 Android O 以下版本中，可以使用 getDeviceId() 方法获取 IMEI 号码
                telephonyManager.deviceId
            }
        }
        return null
    }

    private fun handleBoostRequest(result: MethodChannel.Result) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (ContextCompat.checkSelfPermission(
                    mContext, android.Manifest.permission.KILL_BACKGROUND_PROCESSES
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                pendingResult = result
                ActivityCompat.requestPermissions(
                    mActivity!!,
                    arrayOf(android.Manifest.permission.KILL_BACKGROUND_PROCESSES),
                    PERMISSION_REQUEST_CODE
                )
                return
            }
        }
        val success = cleanMemory()
        if (success) {
            result.success("Memory cleaned successfully")
        } else {
            result.error("UNAVAILABLE", "Memory cleaning failed", null)
        }
    }

    private fun cleanMemory(): Boolean {
        val activityManager = mContext.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val runningAppProcesses = activityManager.runningAppProcesses
        for (processInfo in runningAppProcesses) {
            if (processInfo.processName != mContext.packageName) {
                activityManager.killBackgroundProcesses(processInfo.processName)
            }
        }
        return true
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        mActivity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        mActivity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {

    }

    override fun onDetachedFromActivity() {
    }

//     /**
//      * 初始化SDK
//      */
//     private fun sdkInit(call: MethodCall,result: MethodChannel.Result) {
//         mTokenResultListener = object : TokenResultListener {
//             override fun onTokenSuccess(s: String) {
//                 result.success(s)
//             }

//             override fun onTokenFailed(s: String) {
//                 mAuthHelper?.hideLoginLoading()
//                 result.success(s)
//                 mAuthHelper?.setAuthListener(null)
//             }
//         }

//         mAuthHelper = PhoneNumberAuthHelper.getInstance(mContext, mTokenResultListener)
//         mAuthHelper?.setAuthSDKInfo(call.argument("keySecret"))
//     }

//    public fun numberAuth( timeout:Int) {
//         mAuthHelper?.setAuthListener(mTokenResultListener);
//         mAuthHelper?.getVerifyToken(timeout);
//     }

//     /// 获取运营商
//     private fun getOperator(call: MethodCall,result: MethodChannel.Result) {
//                 var carrierName = "";
//                 if (mAuthHelper == null) {
//                     val phoneNumberAuthHelper = PhoneNumberAuthHelper.getInstance(mActivity, null);
//                     carrierName = phoneNumberAuthHelper.currentCarrierName;
//                 } else {
//                     carrierName = mAuthHelper!!.currentCarrierName;
//                 }
//                 if (carrierName.contains("CMCC")) {
//                     carrierName = "中国移动";
//                 } else if (carrierName.contains("CUCC")) {
//                     carrierName = "中国联通";
//                 } else if (carrierName.contains("CTCC")) {
//                     carrierName = "中国电信";
//                 }
//         result.success(carrierName)
//     }
}
