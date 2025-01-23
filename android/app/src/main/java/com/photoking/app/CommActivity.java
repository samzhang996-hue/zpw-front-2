package com.photoking.app;

import android.content.Intent;
import android.net.Uri;
import android.net.http.SslError;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.webkit.SslErrorHandler;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;

public class CommActivity extends AppCompatActivity {
    private TextView toolbar_name;
    private WebView webview;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_comm);
        findViewById(R.id.ll_left_back).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        toolbar_name=findViewById(R.id.toolbar_name);
        toolbar_name.setText("正在拉起支付...");
        webview=findViewById(R.id.web_view);

        String zfbUrl = getIntent().getStringExtra("zfbUrl");
        WebSettings settings = webview.getSettings();
        settings.setJavaScriptEnabled(true);//必须
        settings.setDomStorageEnabled(true);

        settings.setCacheMode(WebSettings.LOAD_DEFAULT);//关闭webview中缓存

        settings.setUseWideViewPort(false);//WebView是否支持HTML的“viewport”标签或者使用wide viewport。自适应屏幕大小
        //解决支持缩放问题；
        settings.setLoadWithOverviewMode(false);
        settings.setJavaScriptCanOpenWindowsAutomatically(true); //支持通过JS打开新窗口?
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            settings.setMixedContentMode(WebSettings.MIXED_CONTENT_ALWAYS_ALLOW);
        }

        webview.loadUrl(zfbUrl);
        webview.setWebViewClient(new WebViewClient());

        webview.setWebViewClient(new WebViewClient() {
            @Override
            public void onReceivedError(WebView view, int errorCode, String description, String failingUrl) {
                super.onReceivedError(view, errorCode, description, failingUrl);
                // 加载网页失败时处理  如：
                view.loadDataWithBaseURL(null, "<span>页面加载失败,请确认网络是否连接</span>", "text/html", "utf-8", null);
            }

            @Override
            public void onReceivedSslError(WebView view, SslErrorHandler handler, SslError error) {
                super.onReceivedSslError(view, handler, error);
                handler.proceed(); // 忽略 SSL 错误，仅用于开发
            }

            @Override
            public void onPageFinished(WebView view, String url) {
                super.onPageFinished(view, url);
                if (!webview.getSettings().getLoadsImagesAutomatically()) {
                    webview.getSettings().setLoadsImagesAutomatically(true);
                }
            }

            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                // 4.0 之后必须添加该设置
                // 只能加载 http:// 和 https:// 页面 , 不能加载其它协议链接
                if (url.startsWith("http://") || url.startsWith("https://")) {
                    view.loadUrl(url);
                    return true;
                } else {
                    if (url.startsWith("weixin://") || url.startsWith("alipays://")) {
                        Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
                        startActivity(intent);
                        finish();
                        return true;
                    }
                }
                return false;
            }


        });
    }
}