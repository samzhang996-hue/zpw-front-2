package com.muka.device_infos


import android.content.Intent
import android.net.Uri
import android.net.http.SslError
import android.os.Build
import android.os.Bundle
import android.view.View
import android.webkit.SslErrorHandler
import android.webkit.WebSettings
import android.webkit.WebView
import android.webkit.WebViewClient
import android.widget.TextView

class CommActivity : androidx.appcompat.app.AppCompatActivity() {
    private var toolbar_name: TextView? = null
    private var webview: WebView? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_comm)
        findViewById<View>(R.id.ll_left_back).setOnClickListener(View.OnClickListener { finish() })
        toolbar_name = findViewById<TextView>(R.id.toolbar_name)
        toolbar_name!!.text = "正在拉起支付..."
        webview = findViewById<WebView>(R.id.web_view)

        val zfbUrl: String = getIntent().getStringExtra("zfbUrl").toString()
        val settings = webview!!.settings
        settings.javaScriptEnabled = true //必须
        settings.domStorageEnabled = true

        settings.cacheMode = WebSettings.LOAD_DEFAULT //关闭webview中缓存

        settings.useWideViewPort = false //WebView是否支持HTML的“viewport”标签或者使用wide viewport。自适应屏幕大小
        //解决支持缩放问题；
        settings.loadWithOverviewMode = false
        settings.javaScriptCanOpenWindowsAutomatically = true //支持通过JS打开新窗口?
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            settings.mixedContentMode = WebSettings.MIXED_CONTENT_ALWAYS_ALLOW
        }

        webview!!.loadUrl(zfbUrl)
        webview!!.webViewClient = WebViewClient()

        webview!!.webViewClient = object : WebViewClient() {
            override fun onReceivedError(view: WebView, errorCode: Int, description: String, failingUrl: String) {
                super.onReceivedError(view, errorCode, description, failingUrl)
                // 加载网页失败时处理  如：
                view.loadDataWithBaseURL(null, "<span>页面加载失败,请确认网络是否连接</span>", "text/html", "utf-8", null)
            }

            override fun onReceivedSslError(view: WebView, handler: SslErrorHandler, error: SslError) {
                super.onReceivedSslError(view, handler, error)
                handler.proceed() // 忽略 SSL 错误，仅用于开发
            }

            override fun onPageFinished(view: WebView, url: String) {
                super.onPageFinished(view, url)
                if (!webview!!.settings.loadsImagesAutomatically) {
                    webview!!.settings.loadsImagesAutomatically = true
                }
            }

            override fun shouldOverrideUrlLoading(view: WebView, url: String): Boolean {
                // 4.0 之后必须添加该设置
                // 只能加载 http:// 和 https:// 页面 , 不能加载其它协议链接
                if (url.startsWith("http://") || url.startsWith("https://")) {
                    view.loadUrl(url)
                    return true
                } else {
                    if (url.startsWith("weixin://") || url.startsWith("alipays://")) {
                        val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
                        startActivity(intent)
                        finish()
                        return true
                    }
                }
                return false
            }
        }
    }
}