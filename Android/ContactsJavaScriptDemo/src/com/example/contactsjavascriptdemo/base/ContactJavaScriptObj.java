package com.example.contactsjavascriptdemo.base;

import android.content.Context;
import android.os.Handler;
import android.webkit.WebView;

public class ContactJavaScriptObj {

    private Context mContext = null;
    private Handler handler = null;
    private WebView wv = null;
    private static final String JAVASCRIPT = "javascript:";
    private static final String BRC_OPEN = "('";
    private static final String BRC_CLOSE = "')";

    public ContactJavaScriptObj(Context mContext, WebView wv) {
        this.mContext = mContext;
        this.handler = new Handler();
        this.wv = wv;
    }

    public void getContact(String contactId, String callback) {
        String json = ContactUtility.getContactJSON(contactId, mContext.getContentResolver());
        final String callbackFunction = JAVASCRIPT + callback + BRC_OPEN + json + BRC_CLOSE;
        loadURL(callbackFunction);
    }

    public void getAllContacts(String callback) {
        final String json = ContactUtility.getAllContactDisplaysJSON(mContext.getContentResolver());
        final String callbackFunction = JAVASCRIPT + callback + BRC_OPEN + json + BRC_CLOSE;
        loadURL(callbackFunction);
    }

    private void loadURL(final String in) {
        handler.post(new Runnable() {
            public void run() {
                wv.loadUrl(in);
            }
        });
    }
}
