package com.photoking.app.utils;

import android.net.Uri;
import android.view.View;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;


import com.chad.library.adapter.base.BaseQuickAdapter;
import com.chad.library.adapter.base.viewholder.BaseViewHolder;
import com.photoking.app.R;

import java.io.File;
import java.util.List;

public class LjPhotoAdapter extends BaseQuickAdapter<PhotoBean, BaseViewHolder> {
    private OnItemChildClickCallBack mListener;

    public LjPhotoAdapter(@Nullable List<PhotoBean> data) {
        super(R.layout.lj_phioto_item, data);
    }

    @Override
    protected void convert(@NonNull BaseViewHolder baseViewHolder, PhotoBean allPhotoBean) {
        ImageView img = baseViewHolder.getView(R.id.iv_all_img);
//        if (allPhotoBean.getPath().equals("All") && baseViewHolder.getLayoutPosition() == 0) {
//            img.setImageResource(allPhotoBean.img);
//        } else {
            GlideUtils.loadImage(getContext(), Uri.fromFile(new File(allPhotoBean.getImagePath())), img);
//        }

    }

    public interface OnItemChildClickCallBack {
        void onItemClick(View view, PhotoBean allPhotoBean, int position);
    }

    public void setOnItemChildClickBack(OnItemChildClickCallBack listener) {
        mListener = listener;
    }
}
