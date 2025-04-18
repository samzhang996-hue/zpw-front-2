package com.muka.device_infos;


public class DeviceInfo {
    public String aaid;
    public String createBy;
    public String createTime;
    public String deviceId;//设备 ID

    public String imei;
    public String modelInfo;//型号
    public String oaid;
    public String systemInfo;//系统版本号
    public String vaid;
    public String versionInfo;//设备版本号
    public String systemDevice;//平台
    public String mac;//mac地址
    public String androidId;//android ID
    public boolean isRoot;//是否root
    public boolean isAdbEnabled;//判断设备 ADB 是否可用
    public int SDKVersionCode;//获取设备系统版本码
    public String Manufacturer;//厂商
    public String[] ABIs;//设备 ABIs
    public boolean isTablet;//是否是平板
    public boolean isEmulator;//否是模拟器
    public boolean isSameDevice;//是否同一设备
    public int getSDKVersionCode() {
        return SDKVersionCode;
    }

    public void setSDKVersionCode(int SDKVersionCode) {
        this.SDKVersionCode = SDKVersionCode;
    }
    public String[] getABIs() {
        return ABIs;
    }

    public void setABIs(String[] ABIs) {
        this.ABIs = ABIs;
    }


    public String getManufacturer() {
        return Manufacturer;
    }

    public void setManufacturer(String manufacturer) {
        Manufacturer = manufacturer;
    }


    public boolean isTablet() {
        return isTablet;
    }

    public void setTablet(boolean tablet) {
        isTablet = tablet;
    }

    public boolean isEmulator() {
        return isEmulator;
    }

    public void setEmulator(boolean emulator) {
        isEmulator = emulator;
    }



    public boolean isSameDevice() {
        return isSameDevice;
    }

    public void setSameDevice(boolean sameDevice) {
        isSameDevice = sameDevice;
    }

    public boolean isAdbEnabled() {
        return isAdbEnabled;
    }

    public void setAdbEnabled(boolean adbEnabled) {
        isAdbEnabled = adbEnabled;
    }

    public boolean isRoot() {
        return isRoot;
    }

    public void setRoot(boolean root) {
        isRoot = root;
    }

    public String getAndroidId() {
        return androidId;
    }

    public void setAndroidId(String androidId) {
        this.androidId = androidId;
    }

    public String getSystemDevice() {
        return systemDevice;
    }

    public void setSystemDevice(String systemDevice) {
        this.systemDevice = systemDevice;
    }

    public String getMac() {
        return mac;
    }

    public void setMac(String mac) {
        this.mac = mac;
    }

    public String getAaid() {
        return aaid;
    }

    public void setAaid(String aaid) {
        this.aaid = aaid;
    }

    public String getCreateBy() {
        return createBy;
    }

    public void setCreateBy(String createBy) {
        this.createBy = createBy;
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    public String getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(String deviceId) {
        this.deviceId = deviceId;
    }

    public String getImei() {
        return imei;
    }

    public void setImei(String imei) {
        this.imei = imei;
    }

    public String getModelInfo() {
        return modelInfo;
    }

    public void setModelInfo(String modelInfo) {
        this.modelInfo = modelInfo;
    }

    public String getOaid() {
        return oaid;
    }

    public void setOaid(String oaid) {
        this.oaid = oaid;
    }

    public String getSystemInfo() {
        return systemInfo;
    }

    public void setSystemInfo(String systemInfo) {
        this.systemInfo = systemInfo;
    }

    public String getVaid() {
        return vaid;
    }

    public void setVaid(String vaid) {
        this.vaid = vaid;
    }

    public String getVersionInfo() {
        return versionInfo;
    }

    public void setVersionInfo(String versionInfo) {
        this.versionInfo = versionInfo;
    }
}
