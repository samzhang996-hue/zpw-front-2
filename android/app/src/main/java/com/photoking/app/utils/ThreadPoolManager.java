package com.photoking.app.utils;

import java.util.concurrent.Executors;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

/**
 * 线程池管理
 */
public class ThreadPoolManager {
    /**
     * 核心线程池的数量，同时能够执行的线程数量
     */
    private final int corePoolSize;
    /**
     * 最大线程池数量，表示当缓冲队列满的时候能继续容纳的等待任务的数量
     */
    private final int maximumPoolSize;
    /**
     * 存活时间
     */
    private final long keepAliveTime = 1;

    private final TimeUnit unit = TimeUnit.HOURS;
    private final ThreadPoolExecutor executor;
    private static final ThreadPoolManager mInstance = new ThreadPoolManager();

    public static ThreadPoolManager getInstance() {
        return mInstance;
    }

    /**
     * 给corePoolSize赋值：当前设备可用处理器核心数*2 + 1
     */
    public ThreadPoolManager() {
        corePoolSize = Runtime.getRuntime().availableProcessors() * 2 + 1;
        //虽然maximumPoolSize用不到，但是需要赋值，否则报错
        maximumPoolSize = corePoolSize;
        executor = new ThreadPoolExecutor(
                corePoolSize,//当某个核心任务执行完毕，会依次从缓冲队列中取出等待任务
                maximumPoolSize,
                keepAliveTime,
                unit,
                new LinkedBlockingQueue<Runnable>(), //缓冲队列，用于存放等待任务，Linked的先进先出
                Executors.defaultThreadFactory(), //创建线程的工厂
                new ThreadPoolExecutor.AbortPolicy());//用来对超出maximumPoolSize的任务的处理策略
    }

    /**
     * 执行任务
     */
    public void execute(Runnable runnable) {
        if (runnable == null) {
            return;
        }
        executor.execute(runnable);
    }

    /**
     * 从线程池中移除任务
     */
    public void remove(Runnable runnable) {
        if (runnable == null) {
            return;
        }
        executor.remove(runnable);
    }

    public long getCompletedTaskCount() {
        return executor.getCompletedTaskCount();
    }

    public long getTaskCount() {
        return executor.getTaskCount();
    }

    /**
     * 所有线程是否执行完毕
     *
     * @return
     */
    public boolean isThreadPoolExeComplete() {
        return getCompletedTaskCount() == getTaskCount();
    }
}
