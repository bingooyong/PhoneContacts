package com.example.contactsjavascriptdemo.base;

import java.util.ArrayList;

import android.content.Context;
import android.database.Cursor;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.provider.ContactsContract;

public class ContactAsyncTast extends AsyncTask<Cursor, Void, ArrayList<ContactDisplay>> {

    /** 开始整理 */
    public static final int DOWNLOADING_START_MESSAGE = 7;
    /** 整理结束 */
    public static final int DOWNLOAD_END_MESSAGE = 17;
    private Context mContext = null;
    private Handler mHandler = null;

    protected ContactAsyncTast(Context context, Handler handler) {
        this.mContext = context;
        this.mHandler = handler;
    }

    @Override
    protected void onPreExecute() {
        sendStartMessage(DOWNLOADING_START_MESSAGE);
    }

    @Override
    protected void onPostExecute(ArrayList<ContactDisplay> result) {
        sendEndMessage(DOWNLOAD_END_MESSAGE, result);
    }

    public static void startRequestServerData(Context context, Handler handler,
            Cursor cursor) {
        new ContactAsyncTast(context, handler).execute(cursor);
    }

    /**
     * 发送开始整理消息
     *
     * @param messageWhat
     */
    private void sendStartMessage(int messageWhat) {
        Message message = new Message();
        message.what = messageWhat;
        if (mHandler != null) {
            mHandler.sendMessage(message);
        }
    }

    /**
     * 发送整理结束消息
     *
     * @param messageWhat
     */
    private void sendEndMessage(int messageWhat, ArrayList<ContactDisplay> result) {
        Message message = new Message();
        message.what = messageWhat;
        Bundle bundle = new Bundle();
        bundle.putSerializable("完成", result);
        message.setData(bundle);
        if (mHandler != null) {
            mHandler.sendMessage(message);
        }
    }

    @Override
    protected ArrayList<ContactDisplay> doInBackground(Cursor... params) {
        Cursor cursor = params[0];
        ArrayList<ContactDisplay> list = new ArrayList<ContactDisplay>();
        if (cursor.getCount() > 0) {
            while (cursor.moveToNext()) {
                String id = cursor.getString(cursor.getColumnIndex(ContactsContract.Contacts._ID));
                String displayName = cursor
                        .getString(cursor
                                .getColumnIndex(ContactsContract.Contacts.DISPLAY_NAME));
                ContactDisplay display = new ContactDisplay();
                display.setContactId(id);
                display.setDisplayName(displayName);
                list.add(display);
            }
            cursor.close();
        }

        return list;
    }

}
