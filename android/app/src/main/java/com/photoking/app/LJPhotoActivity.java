package com.photoking.app;

import static android.os.Environment.DIRECTORY_DCIM;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.pm.ActivityInfo;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;


import com.chad.library.adapter.base.BaseQuickAdapter;
import com.chad.library.adapter.base.listener.OnItemClickListener;
import com.photoking.app.utils.ImageUtils;
import com.photoking.app.utils.LjPhotoAdapter;
import com.photoking.app.utils.LjPhotoDialog;
import com.photoking.app.utils.LoadingProgressDialog;
import com.photoking.app.utils.PhotoBean;
import com.photoking.app.utils.ThreadPoolManager;

import java.io.File;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;


public class LJPhotoActivity extends AppCompatActivity {
    RecyclerView recycler_ljPhoto;
    TextView toolbar_name;
    LinearLayout ll_left_back;
    LjPhotoAdapter ljPhotoAdapter;

    private LoadingProgressDialog mProgressDialog;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.activity_ljphoto);
        setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
        getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_VISIBLE);
        fullScreen(this);
        toolbar_name = findViewById(R.id.toolbar_name);
        recycler_ljPhoto = findViewById(R.id.recycler_ljPhoto);
        findViewById(R.id.ll_left_back).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });

        showLoading("正在扫描...");
        toolbar_name.setText("相册恢复");
        findViewById(R.id.ll_left_back).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });

        ThreadPoolManager.getInstance().execute(new Runnable() {
            @Override
            public void run() {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        getAllPhotoData();
                    }
                });
            }
        });
    }
    /**
     * 通过设置全屏，设置状态栏透明
     */
    private void fullScreen(Activity activity) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            Window window = activity.getWindow();
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                //5.x开始需要把颜色设置透明，否则导航栏会呈现系统默认的浅灰色
                View decorView = window.getDecorView();
                //两个 flag 要结合使用，表示让应用的主体内容占用系统状态栏的空间
                int option = View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN | View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR;
                decorView.setSystemUiVisibility(option);
                window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
                window.setStatusBarColor(Color.TRANSPARENT);
            } else {
                WindowManager.LayoutParams attributes = window.getAttributes();
                int flagTranslucentStatus = WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS;
                attributes.flags |= flagTranslucentStatus;
                window.setAttributes(attributes);
            }
        }
    }
    @SuppressLint("Range")
    public void getAllPhotoData() {
        List<PhotoBean> photoBeanList = getAllShownImages();
        hideLoading();
        ljPhotoAdapter = new LjPhotoAdapter(photoBeanList);
        recycler_ljPhoto.setLayoutManager(new GridLayoutManager(this, 3, RecyclerView.VERTICAL, false));
        recycler_ljPhoto.setAdapter(ljPhotoAdapter);
        ljPhotoAdapter.setOnItemClickListener(new OnItemClickListener() {
            @Override
            public void onItemClick(@NonNull BaseQuickAdapter<?, ?> adapter, @NonNull View view, int position) {
                PhotoBean o = (PhotoBean) adapter.getData().get(position);
                LjPhotoDialog ljPhotoDialog = new LjPhotoDialog(LJPhotoActivity.this);
                ljPhotoDialog.show();
                ljPhotoDialog.setOnConfirmClickListener(new LjPhotoDialog.OnConfirmClickListener() {
                    @Override
                    public void onLeftClick() {
                        ljPhotoDialog.dismiss();
                    }

                    @Override
                    public void onRightClick() {
                        saveImageToGallery(o.getImagePath());
                        ljPhotoDialog.dismiss();
                    }
                });
            }
        });
    }

    public List<PhotoBean> getAllShownImages() {
        List<PhotoBean> listOfAllImages = new ArrayList<>();
        File rootDir = Environment.getExternalStorageDirectory();
        // 调用递归函数来遍历目录
        traverseDirectory(rootDir, listOfAllImages);
        return listOfAllImages;
    }


    private void traverseDirectory(File dir, List<PhotoBean> listOfAllImages) {
        if (dir == null || !dir.exists() || !dir.isDirectory()) {
            return;
        }
        File[] files = dir.listFiles();
        if (files != null) {
            for (File file : files) {
                if (file.isDirectory()) {
                    // 递归遍历子目录
                    traverseDirectory(file, listOfAllImages);
                } else {
                    // 检查文件扩展名
                    String fileName = file.getName().toLowerCase();
                    if (fileName.endsWith(".jpg") || fileName.endsWith(".png") || fileName.endsWith(".mp4")) {
                        if ((file.getAbsolutePath().toLowerCase().contains("trash") ||
                                file.getAbsolutePath().toLowerCase().contains("dcim") ||
                                file.getAbsolutePath().toLowerCase().contains("recycle") ||
                                file.getAbsolutePath().toLowerCase().contains("pictures"))
                        ) {
                            listOfAllImages.add(new PhotoBean(file.getAbsolutePath()));
                        }
                    }
                }
            }
        }
    }

    public void showLoading(String msg) {
        if (mProgressDialog == null) {
            mProgressDialog = new LoadingProgressDialog(this, msg);
            mProgressDialog.getWindow().setBackgroundDrawable(new ColorDrawable(android.graphics.Color.TRANSPARENT));
            mProgressDialog.setCancelable(false);
        }
        mProgressDialog.show();
    }

    // 隐藏网络加载的进度条
    public void hideLoading() {
        if (mProgressDialog != null && mProgressDialog.isShowing()) {
            mProgressDialog.dismiss();
        }
    }

    private void saveImageToGallery(String imagePath) {
        String sourcePath = imagePath;
        File destDir = Environment.getExternalStoragePublicDirectory(DIRECTORY_DCIM); // 应用私有目录
        String destPath = destDir.getAbsolutePath() + File.separator + System.currentTimeMillis()+"_saved_image.jpg";

        boolean isSaved = ImageUtils.saveImage(this, sourcePath, destPath);
        if (isSaved) {
            // 保存成功
            Toast.makeText(this, "恢复成功!可到相册查看", Toast.LENGTH_LONG).show();
        } else {
            // 保存失败
            Toast.makeText(this, "恢复失败", Toast.LENGTH_LONG).show();
        }
    }


}