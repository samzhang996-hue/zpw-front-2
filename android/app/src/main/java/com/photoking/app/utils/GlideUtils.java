package com.photoking.app.utils;

import android.content.Context;
import android.net.Uri;
import android.widget.ImageView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.request.RequestOptions;
import com.photoking.app.R;


/**
 * Glide工具类
 */
public class GlideUtils {
    /*** 占位图 */
    public static int placeholderImage = R.drawable.bg_def;
    /*** 错误图 */
    public static int errorImage = R.drawable.bg_def;

    /**
     * 加载图片(默认)
     *
     * @param context   上下文
     * @param url       链接
     * @param imageView ImageView
     */
    public static void loadImage(Context context, String url, ImageView imageView) {
        RequestOptions options = new RequestOptions()
                .placeholder(placeholderImage) //占位图
                .error(errorImage);            //错误图
        Glide.with(context).load(url).apply(options).into(imageView);

    }


    public static void loadImage(Context context, Uri url, ImageView imageView) {
        RequestOptions options = new RequestOptions()
                .placeholder(placeholderImage) //占位图
                .error(errorImage);            //错误图
        Glide.with(context).load(url).apply(options).into(imageView);

    }



    public interface OnWebpAnimationLoadedListener {
        void onWebpAnimationLoaded();
    }
}