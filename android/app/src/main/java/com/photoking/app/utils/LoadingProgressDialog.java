package com.photoking.app.utils;

import android.annotation.SuppressLint;
import android.app.ProgressDialog;
import android.content.Context;
import android.os.Bundle;
import android.text.TextUtils;
import android.widget.TextView;

import com.photoking.app.R;


public class LoadingProgressDialog extends ProgressDialog {
    TextView progress_text;
    String msg;

    public LoadingProgressDialog(Context context) {
        super(context);
    }
    public LoadingProgressDialog(Context context, String msg) {
        super(context);
        this.msg=msg;
    }
    @SuppressLint("ResourceType")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.custom_progress_dialog);
        // 将弹窗背景色设置成透明
        getWindow().setBackgroundDrawableResource(R.color.transparent);
        // 弹窗外部蒙层不可取消弹窗
        setCanceledOnTouchOutside(false);
        progress_text = findViewById(R.id.progress_text);
        if(!TextUtils.isEmpty(msg)){
            setMessage(msg);
        }
    }

    public void setMessage(String msg) {
        this.msg = msg;
        if (progress_text != null) {
            progress_text.setText(msg);
        }
    }
}
