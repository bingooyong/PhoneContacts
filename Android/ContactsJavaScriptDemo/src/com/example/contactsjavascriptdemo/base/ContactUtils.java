package com.example.contactsjavascriptdemo.base;

import java.util.Map;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.webkit.WebResourceResponse;
import android.webkit.WebView;
import android.webkit.WebViewClient;

public class ContactUtils {

    public static final String SCRIPT_TO_JAVA_PREFIX = "http://www.thev5.com";

    public static boolean isCallFromJavaScript(String url) {
        return url != null && url.startsWith(SCRIPT_TO_JAVA_PREFIX);
    }

    @SuppressLint("NewApi")
    public static WebResourceResponse callFromJavaScript(Activity activity, WebViewClient wc, WebView webview,
            String url) {
        if (url.equals(SCRIPT_TO_JAVA_PREFIX + "/contacts_lists")) {
            final String contacts = ContactUtility.getAllContactDisplaysJSON(activity.getContentResolver());
            return new WebResourceResponse("application/json; charset=UTF-8", null, Utils.str2stream(contacts));
        }
        if (url.startsWith(SCRIPT_TO_JAVA_PREFIX + "/contacts_detail")) {
            Map<String, String> params = Utils.parseParams(url);
            String contact = ContactUtility.getContactJSON(params.get("id"), activity.getContentResolver());
            return new WebResourceResponse("application/json; charset=UTF-8", null, Utils.str2stream(contact));
        }
        return wc.shouldInterceptRequest(webview, url);
    }

}
