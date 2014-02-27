package com.example.contactsjavascriptdemo;

import java.util.Map;

import com.example.contactsjavascriptdemo.base.ContactUtils;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.ProgressDialog;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.Menu;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceResponse;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Toast;

public class MainActivity extends Activity {

    WebView wv;
    Handler handler;
    ProgressDialog pd;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // setContentView(R.layout.activity_main);

        init();// 执行初始化函数
        loadurl(wv, "http://www.thev5.com/lvyong/android/www/ListPage1.html");

        handler = new Handler() {
            public void handleMessage(Message msg) {// 定义一个Handler，用于处理下载线程与UI间通讯
                if (!Thread.currentThread().isInterrupted()) {
                    switch (msg.what) {
                    case 0:
                        pd.show();// 显示进度对话框
                        break;
                    case 1:
                        pd.hide();// 隐藏进度对话框，不可使用dismiss()、cancel(),否则再次调用show()时，显示的对话框小圆圈不会动。
                        break;
                    }
                }
                super.handleMessage(msg);
            }
        };

        // 设置Web视图
        setContentView(wv);
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
        wv.addJavascriptInterface(this, "wst");
        wv.setWebViewClient(new WebViewClient() {
            public boolean shouldOverrideUrlLoading(final WebView view,
                    final String url) {
                loadurl(view, url);// 载入网页
                return true;
            }// 重写点击动作,用webview载入

            @SuppressLint("NewApi")
            public WebResourceResponse shouldInterceptRequest(WebView view, String url) {
                if(ContactUtils.isCallFromJavaScript(url)){
                    return ContactUtils.callFromJavaScript(MainActivity.this, this, view, url);
                }
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
                handler.sendEmptyMessage(0);
                view.loadUrl(url);// 载入网页
            }
        }.start();
    }

    public void startFunction() {
        Toast.makeText(this, "js调用了java函数", Toast.LENGTH_SHORT).show();
        runOnUiThread(new Runnable() {

            @Override
            public void run() {
                Log.d("", "This is Debug." + "\njs调用了java函数");

            }
        });
    }

    public void startFunction(final String str) {
        Toast.makeText(this, str, Toast.LENGTH_SHORT).show();
        runOnUiThread(new Runnable() {

            @Override
            public void run() {
                Log.d("", "This is Debug." + "\njs调用了java函数传递参数：" + str);

                // 无参数调用
                wv.loadUrl("javascript:javacalljs()");
                // 传递参数调用
                wv.loadUrl("javascript:javacalljswithargs(" + "'hello world'"
                        + ")");
            }
        });
    }

}
