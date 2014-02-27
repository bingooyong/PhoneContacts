package com.example.contactsjavascriptdemo.base;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.http.NameValuePair;
import org.apache.http.client.utils.URLEncodedUtils;

public class Utils {

    public static final String CHARSET = "utf-8";

    public static Map<String, String> parseParams(String url) {

        HashMap<String, String> params = new HashMap<String, String>();
        List<NameValuePair> parameters = null;
        try {
            parameters = URLEncodedUtils.parse(new URI(url), CHARSET);
        } catch (URISyntaxException e) {
            return params;
        }
        for (NameValuePair p : parameters) {
            params.put(p.getName(), p.getValue());
        }
        return params;
    }

    public static InputStream str2stream(String src) {
        java.io.InputStream stream = null;
        try {
            stream = new ByteArrayInputStream(src.toString().getBytes(CHARSET));
        } catch (UnsupportedEncodingException e) {
        }
        return stream;
    }

}
