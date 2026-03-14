package com.photoking.app.utils;


import static com.blankj.utilcode.util.ActivityUtils.startActivity;

import android.app.Activity;

import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;

import android.net.Uri;
import android.os.Bundle;

import android.provider.Settings.Secure;
import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.NonNull;

import com.blankj.utilcode.util.ActivityUtils;
import com.bytedance.ads.convert.BDConvert;
import com.bytedance.applog.AppLog;
import com.bytedance.applog.InitConfig;
import com.bytedance.applog.util.UriConstants;
import com.photoking.app.CommActivity;
import com.photoking.app.LJPhotoActivity;
import com.umeng.commonsdk.UMConfigure;
import com.umeng.commonsdk.listener.OnGetOaidListener;

import java.net.URLEncoder;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import com.meituan.android.walle.WalleChannelReader;
import android.provider.Settings;
import android.content.Intent;
import android.provider.Settings;

public class ZpwPlugin implements MethodChannel.MethodCallHandler, EventChannel.StreamHandler {
    public static final String KEY_SPLASH = "zpwSplashId";
    public static final String KEY_BANNER = "zpwBannerId";
    public static final String KEY_FEED = "zpwFeedId";
    public static final String KEY_BANNER_VIEW = "zpw_ads_banner";
    // Feed View
    public static final String KEY_FEED_VIEW = "zpw_ads_feed";
    private static MethodChannel zpwChannel;

    private EventChannel.EventSink zpwEventSink;
    private static EventChannel zpwEventChannel;
    public static Activity zpwActivity;

    public static FlutterPlugin.FlutterPluginBinding zpwBinding;

    private static ZpwPlugin _instance;

    public static ZpwPlugin getInstance() {
        return _instance;
    }

    public static BinaryMessenger zpwBinaryMessenger;

    public static ZpwPlugin registerWith(BinaryMessenger b, FlutterActivity activity) {
        zpwBinaryMessenger = b;
        zpwChannel = new MethodChannel(zpwBinaryMessenger, "zpw_plugin");
        zpwEventChannel = new EventChannel(zpwBinaryMessenger, "zpw_ads_event");
        ZpwPlugin zpwPlugin = new ZpwPlugin(activity, zpwChannel);
        zpwChannel.setMethodCallHandler(zpwPlugin);
        zpwEventChannel.setStreamHandler(zpwPlugin);
        return zpwPlugin;
    }

    private ZpwPlugin(Activity activity, MethodChannel channel) {
        this.zpwChannel = channel;
        this.zpwActivity = activity;
        _instance = this;
        UMConfigure.init(activity, "", "cx", UMConfigure.DEVICE_TYPE_PHONE, "");
    }


    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        String method = call.method;
        switch (method) {
            case "getDeviceId":
                result.success(Secure.getString(zpwActivity.getContentResolver(), Secure.ANDROID_ID));
                break;
            case "getOAID":
                UMConfigure.getOaid(zpwActivity, new OnGetOaidListener() {
                    public void onGetOaid(String s) {
                        result.success(TextUtils.isEmpty(s) ? "" : s);
                    }
                });
                break;
            case "getChannelInfo":
                String _channel = WalleChannelReader.getChannel(zpwActivity);
                _channel = TextUtils.isEmpty(_channel) ? "AIJL300" : _channel;
                result.success(_channel);
                break;
            case "projectId":
                String projectId2 = WalleChannelReader.get(zpwActivity, "projectId");
                projectId2 = TextUtils.isEmpty(projectId2) ? "34" : projectId2;
                result.success(projectId2);
                break;
            case "setOrderZfb":
                String url = call.argument("message");
                Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
                zpwActivity.startActivity(intent);
                break;
            case "onH5":
                String h5url = call.argument("url");
                Intent intent1 = new Intent(zpwActivity, CommActivity.class);
                intent1.putExtra("zfbUrl", h5url);
                ActivityUtils.startActivity(intent1);
                break;
            case "startPhoto":
                startActivity(LJPhotoActivity.class);
                break;
            case "getAndroidID":
                result.success(Settings.Secure.getString(zpwActivity.getContentResolver(), Settings.Secure.ANDROID_ID));
                break;
            case "RangerInit":
                zpwRangerInit();
                break;
            case "getUA": {
                result.success(System.getProperty("http.agent"));
                break;
            }

        }
    }

    private void zpwRangerInit() {
        final InitConfig config = new InitConfig("507185", "AIJL300");
        // 设置数据上送地址
        config.setUriConfig(UriConstants.DEFAULT);
        config.setImeiEnable(false);//建议关停获取IMEI（出于合规考虑）
        config.setAutoTrackEnabled(false); // 全埋点开关，true开启，false关闭
        config.setLogEnable(false); // true:开启日志，参考4.3节设置logger，false:关闭日志
        AppLog.setEncryptAndCompress(true); // 加密开关，true开启，false关闭
        config.setEnablePlay(true); // 配置心跳事件（时长统计）

        //SDK会采集OAID、ANDROID_ID和其他的设备特征字段，请遵循相关合规要求在隐私弹窗后采集
        BDConvert.getInstance().init(zpwActivity, AppLog.getInstance());
        // 如果在 onCreate 阶段初始化拿不到 XXXActivity 则不需要传递第三个参数
        AppLog.init(zpwActivity, config);
        /* 初始化SDK结束 */
    }


    /**
     * 支付宝小程序
     *
     * @param query 启动参数，内容按照格式为参数名=参数值&参数名=参数值…之后encode，例如：client_type=2
     */
    public static void start2(String query) {
        try {
            StringBuffer sb = new StringBuffer("alipays://platformapi/startapp?");
            String link = URLEncoder.encode(query, "UTF-8");
            sb.append("appId=").append("2021004160634906").append("&");
            sb.append("page=").append("pages/new/new?").append(link);
            Uri uri = Uri.parse(sb.toString());
            Intent intent = new Intent(Intent.ACTION_VIEW, uri);
            zpwActivity.startActivity(intent);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 支付宝小程序
     *
     * @param appId 小程序appId
     * @param page  小程序跳转的页面。如果不设置，默认为跳转至首页。例如：pages/user/user
     * @param query 启动参数，内容按照格式为参数名=参数值&参数名=参数值…之后encode，例如：client_type=2
     */
    public static void start(String appId, String page, String query) {
        try {
            StringBuffer sb = new StringBuffer("alipays://platformapi/startapp?");
            String link = URLEncoder.encode(query, "UTF-8");
            sb.append("appId=").append(appId).append("&");
            sb.append("page=").append(page).append(link);
            Uri uri = Uri.parse(sb.toString());
            Intent intent = new Intent(Intent.ACTION_VIEW, uri);
            zpwActivity.startActivity(intent);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 建立事件通道监听
     *
     * @param arguments 参数
     * @param events    事件回调对象
     */
    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        Log.d("ZpwPlugin", "EventChannel onListen arguments:" + arguments);
        zpwEventSink = events;
    }

    @Override
    public void onCancel(Object arguments) {
        Log.d("ZpwPlugin", "EventChannel onCancel");
        zpwEventSink = null;
    }

    /**
     * 添加事件
     *
     * @param event 事件
     */
    public void addEvent(Object event) {
        if (zpwEventSink != null) {
            Log.d("ZpwPlugin", "EventChannel addEvent event:" + event.toString());
            zpwEventSink.success(event);
        }
    }


}