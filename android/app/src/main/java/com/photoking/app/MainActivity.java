package com.photoking.app;

import android.os.Bundle;

import com.blankj.utilcode.util.LogUtils;
import com.photoking.app.utils.MyPlugin;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;

public class MainActivity extends FlutterActivity {
//    static {
//        try {
//            System.loadLibrary("opencv_java4"); // 加载 OpenCV 库
//            LogUtils.d("OpenCV", "OpenCV 库加载成功");
//        } catch (UnsatisfiedLinkError e) {
//            LogUtils.e("OpenCV", "OpenCV 库加载失败: " + e.getMessage());
//        }
//    }

    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        //注册插件
        MyPlugin.registerWith(flutterEngine.getDartExecutor().getBinaryMessenger(), this);

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }
}
