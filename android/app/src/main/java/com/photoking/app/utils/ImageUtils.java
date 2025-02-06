package com.photoking.app.utils;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

public class ImageUtils {

    /**
     * 保存照片到指定路径
     *
     * @param context 上下文
     * @param sourcePath 源图片路径
     * @param destPath 目标保存路径
     * @return 保存成功返回true，否则返回false
     */
    public static boolean saveImage(Context context, String sourcePath, String destPath) {
        File sourceFile = new File(sourcePath);
        if (!sourceFile.exists()) {
            return false;
        }

        Bitmap bitmap = null;
        try (InputStream in = context.getContentResolver().openInputStream(Uri.fromFile(sourceFile))) {
            if (in != null) {
                bitmap = BitmapFactory.decodeStream(in);
            }
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }

        if (bitmap == null) {
            return false;
        }

        File destFile = new File(destPath);
        File parentDir = destFile.getParentFile();
        if (!parentDir.exists()) {
            parentDir.mkdirs();
        }

        return saveBitmapToFile(bitmap, destFile);
    }

    /**
     * 将Bitmap保存到文件
     *
     * @param bitmap 要保存的Bitmap
     * @param file 目标文件
     * @return 保存成功返回true，否则返回false
     */
    private static boolean saveBitmapToFile(Bitmap bitmap, File file) {
        FileOutputStream out = null;
        try {
            out = new FileOutputStream(file);
            if (bitmap.compress(Bitmap.CompressFormat.JPEG, 100, out)) {
                return true;
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (out != null) {
                try {
                    out.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return false;
    }
}
