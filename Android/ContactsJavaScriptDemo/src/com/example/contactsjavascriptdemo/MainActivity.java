package com.example.contactsjavascriptdemo;

import com.example.contactsjavascriptdemo.base.ContactJavaScriptObj;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.ProgressDialog;
import android.os.Bundle;
import android.os.Handler;
import android.view.Menu;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceResponse;
import android.webkit.WebView;
import android.webkit.WebViewClient;

@SuppressLint("JavascriptInterface")
public class MainActivity extends Activity {

    WebView wv;
    ProgressDialog pd;
    Handler handler = null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        init();// 执行初始化函数
        loadurl(wv, "http://www.thev5.com/lvyong/android/www/ListPageAndroid.html");
        setContentView(wv);

        handler = new Handler();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }

    @SuppressLint("JavascriptInterface")
    public void init() {// 初始化
        wv = new WebView(this);
        wv.getSettings().setJavaScriptEnabled(true);// 可用JS
        wv.setScrollBarStyle(0);// 滚动条风格，为0就是不给滚动条留空间，滚动条覆盖在网页上
        wv.addJavascriptInterface(new ContactJavaScriptObj(this, this.wv), "ailkContactSupport");
        wv.setWebViewClient(new WebViewClient() {
            public boolean shouldOverrideUrlLoading(final WebView view,
                    final String url) {
                loadurl(view, url);// 载入网页
                return true;
            }// 重写点击动作,用webview载入

            @SuppressLint("NewApi")
            public WebResourceResponse shouldInterceptRequest(WebView view, String url) {
                return super.shouldInterceptRequest(view, url);
            }

        });
        wv.setWebChromeClient(new WebChromeClient() {
            public void onProgressChanged(WebView view, int progress) {// 载入进度改变而触发
                int progress2 = progress;
                if (progress2 == 100) {
                    handler.sendEmptyMessage(1);// 如果全部载入,隐藏进度对话框
                }
                super.onProgressChanged(view, progress2);
            }
        });

        pd = new ProgressDialog(MainActivity.this);
        pd.setProgressStyle(ProgressDialog.STYLE_SPINNER);
        pd.setMessage("数据载入中，请稍候！");
    }

    public void loadurl(final WebView view, final String url) {
        new Thread() {
            public void run() {
                view.loadUrl(url);// 载入网页
            }
        }.start();
    }

}
