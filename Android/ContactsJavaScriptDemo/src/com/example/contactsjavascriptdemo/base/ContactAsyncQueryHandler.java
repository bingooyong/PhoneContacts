package com.example.contactsjavascriptdemo.base;

import java.util.ArrayList;

import android.content.AsyncQueryHandler;
import android.content.ContentResolver;
import android.content.Context;
import android.database.Cursor;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;

public class ContactAsyncQueryHandler extends AsyncQueryHandler {

    private Context mContext = null;

    private ArrayList<ContactDisplay> contactDisplays = null;

    public ContactAsyncQueryHandler(ContentResolver cr, Context mContext) {
        super(cr);
        this.mContext = mContext;
    }

    protected void onQueryComplete(int token, Object cookie, Cursor cursor) {
        Handler handlerInsertOrder = new Handler() {
            public void handleMessage(Message msg) {
                switch (msg.what) {
                case ContactAsyncTast.DOWNLOADING_START_MESSAGE:
                    System.out.println("begin to sort out t9");
                    break;
                case ContactAsyncTast.DOWNLOAD_END_MESSAGE:
                    Bundle bundle1 = msg.getData();
                    contactDisplays = (ArrayList<ContactDisplay>) bundle1.get("完成");
                    break;
                default:
                    break;
                }
                super.handleMessage(msg);
            }
        };
        ContactAsyncTast.startRequestServerData(mContext, handlerInsertOrder, cursor);
    }

    public ArrayList<ContactDisplay> getContactDisplays() {
        return contactDisplays;
    }

    public void setContactDisplays(ArrayList<ContactDisplay> contactDisplays) {
        this.contactDisplays = contactDisplays;
    }
}
