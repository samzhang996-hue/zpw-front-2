package com.photoking.app.utils;

import android.annotation.SuppressLint;
import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.view.View;
import android.widget.LinearLayout;

import com.photoking.app.R;


public class LjPhotoDialog extends Dialog implements View.OnClickListener {
    private LinearLayout ll_dismiss;
    private LinearLayout ll_sure;
    private OnConfirmClickListener mOnConfirmClickListener;

    public LjPhotoDialog(Context context) {
        super(context);
    }

    @SuppressLint("ResourceType")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.dialog_ljphoto);
        // 将弹窗背景色设置成透明
        getWindow().setBackgroundDrawableResource(R.color.transparent);
        // 弹窗外部蒙层不可取消弹窗
        setCanceledOnTouchOutside(false);
        ll_dismiss = findViewById(R.id.ll_dismiss);
        ll_sure = findViewById(R.id.ll_sure);
        ll_dismiss.setOnClickListener(this);
        ll_sure.setOnClickListener(this);
    }

    public void setOnConfirmClickListener(OnConfirmClickListener listener) {
        mOnConfirmClickListener = listener;
    }

    public interface OnConfirmClickListener {
        /**
         * 点击左侧按钮
         */
        void onLeftClick();

        /**
         * 点击右侧按钮
         */
        void onRightClick();
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.ll_dismiss:
                if (mOnConfirmClickListener != null) {
                    mOnConfirmClickListener.onLeftClick();
                }
                break;
            case R.id.ll_sure:
                if (mOnConfirmClickListener != null) {
                    mOnConfirmClickListener.onRightClick();
                }

                break;
        }
    }

}
