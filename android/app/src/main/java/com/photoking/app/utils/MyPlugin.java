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

import android.content.Intent;

import org.opencv.core.Mat;


public class MyPlugin implements MethodChannel.MethodCallHandler, EventChannel.StreamHandler {
    public static final String KEY_SPLASH = "splashId";
    public static final String KEY_BANNER = "bannerId";
    public static final String KEY_FEED = "feedId";
    public static final String KEY_BANNER_VIEW = "ads_banner";
    // Feed View
    public static final String KEY_FEED_VIEW = "ads_feed";
    private static MethodChannel channel;

    private EventChannel.EventSink eventSink;
    private static EventChannel eventChannel;
    public static Activity activity;

    public static FlutterPlugin.FlutterPluginBinding bind;

    private static MyPlugin _instance;

    public static MyPlugin getInstance() {
        return _instance;
    }

    public static BinaryMessenger binaryMessenger;

    public static MyPlugin registerWith(BinaryMessenger b, FlutterActivity activity) {
        binaryMessenger = b;
        channel = new MethodChannel(binaryMessenger, "MyPlugin");
        eventChannel = new EventChannel(binaryMessenger, "ads_event");
        MyPlugin myPlugin = new MyPlugin(activity, channel);
        channel.setMethodCallHandler(myPlugin);
        eventChannel.setStreamHandler(myPlugin);
        return myPlugin;
    }

    private MyPlugin(Activity activity, MethodChannel channel) {
        this.channel = channel;
        this.activity = activity;
        _instance = this;
        UMConfigure.init(activity, "", "cx", UMConfigure.DEVICE_TYPE_PHONE, "");
    }


    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        String method = call.method;
        switch (method) {
            case "getDeviceId":
                result.success(Secure.getString(activity.getContentResolver(), Secure.ANDROID_ID));
                break;
            case "getOAID":
                UMConfigure.getOaid(activity, new OnGetOaidListener() {
                    public void onGetOaid(String s) {
                        result.success(TextUtils.isEmpty(s) ? "" : s);
                    }
                });
                break;
            case "getChannelInfo":
                String _channel = WalleChannelReader.getChannel(activity);
                _channel = TextUtils.isEmpty(_channel) ? "ZPAIJL300" : _channel;
                result.success(_channel);
                break;
            case "projectId":
                String projectId2 = WalleChannelReader.get(activity, "projectId");
                projectId2 = TextUtils.isEmpty(projectId2) ? "34" : projectId2;
                result.success(projectId2);
                break;
            case "setOrderZfb":
                String url = call.argument("message");
                Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
                activity.startActivity(intent);
                break;
            case "onH5":
                String h5url = call.argument("url");
                Intent intent1 = new Intent(activity, CommActivity.class);
                intent1.putExtra("zfbUrl", h5url);
                ActivityUtils.startActivity(intent1);
                break;
            case "startPhoto":
                startActivity(LJPhotoActivity.class);
                break;
        }
    }
    private boolean inpaint(String imagePath, String maskPath, String outputPath, int radius) {
        try {
            Mat image = org.opencv.imgcodecs.Imgcodecs.imread(imagePath);
            Mat mask = org.opencv.imgcodecs.Imgcodecs.imread(maskPath, org.opencv.imgcodecs.Imgcodecs.IMREAD_GRAYSCALE);
            Mat result = new Mat();

            org.opencv.photo.Photo.inpaint(image, mask, result, radius, org.opencv.photo.Photo.INPAINT_TELEA);

            return org.opencv.imgcodecs.Imgcodecs.imwrite(outputPath, result);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
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
            activity.startActivity(intent);
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
//            sb.append("page=").append(page).append("&");
//            sb.append("query=").append(link);
            Uri uri = Uri.parse(sb.toString());
            Intent intent = new Intent(Intent.ACTION_VIEW, uri);
            activity.startActivity(intent);
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
        Log.d("MyPlugin", "EventChannel onListen arguments:" + arguments);
        eventSink = events;
    }

    @Override
    public void onCancel(Object arguments) {
        Log.d("MyPlugin", "EventChannel onCancel");
        eventSink = null;
    }

    /**
     * 添加事件
     *
     * @param event 事件
     */
    public void addEvent(Object event) {
        if (eventSink != null) {
            Log.d("MyPlugin", "EventChannel addEvent event:" + event.toString());
            eventSink.success(event);
        }
    }


}
