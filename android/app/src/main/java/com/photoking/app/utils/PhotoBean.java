package com.photoking.app.utils;

public class PhotoBean {
    private String imagePath;
    private boolean isSelect;

    public PhotoBean(String imagePath, boolean isSelect) {
        this.imagePath = imagePath;
        this.isSelect = isSelect;
    }

    public boolean isSelect() {
        return isSelect;
    }

    public void setSelect(boolean select) {
        isSelect = select;
    }

    public PhotoBean(String imagePath) {
        this.imagePath = imagePath;
    }

    public String getImagePath() {
        return imagePath;
    }
}
