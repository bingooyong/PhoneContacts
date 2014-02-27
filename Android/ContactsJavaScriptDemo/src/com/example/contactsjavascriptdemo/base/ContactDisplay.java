package com.example.contactsjavascriptdemo.base;

public class ContactDisplay implements Comparable<Object> {
    private String contactId;
    private String displayName;

    public String getContactId() {
        return contactId;
    }

    public void setContactId(String contactId) {
        this.contactId = contactId;
    }

    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }

    public String getKey() {
        if (displayName == null || "".equals(displayName)) { return ""; }
        return String.valueOf(PinyinUtils.charWithPinyinFirstLetter(displayName.charAt(0))).toUpperCase();
    }

    public int compareTo(Object arg0) {
        if (arg0 == null || !this.getClass().equals(arg0.getClass())) { return 1; }
        String otherKey = ((ContactDisplay) arg0).getKey();
        String key = getKey();
        if (key == null) return otherKey == null ? 0 : -1;
        if ("#".equals(key) || "#".equals(otherKey)) return otherKey.compareToIgnoreCase(key);// "#"排在最后
        return otherKey == null ? 1 : key.compareToIgnoreCase(otherKey);
    }
}
