import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:openai_dart/openai_dart.dart';
import 'package:zpw/common/constant.dart';
import '../../common/cached_image/cached_image.dart';
import '../../common/view/comm_text.dart';
import '../../model/smart_model.dart';
import '../../utils/handle_tool.dart';
import 'chat_controller.dart';

class ChatView extends StatelessWidget {
  final SmartModel arg;

  const ChatView({
    super.key,
    required this.arg,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ChatController(arg: arg),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: Text(controller.arg.name),
          centerTitle: true,
          actions: [
            PopupMenuButton(
              padding: EdgeInsets.zero,
              menuPadding: EdgeInsets.zero,
              splashRadius: 14.r,
              offset: Offset(-20.w, 40.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14.r)).copyWith(topRight: Radius.zero)),
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(
                  onTap: controller.clearMessage,
                  child: Text('清空对话', style: TextStyle(fontSize: 14.sp)),
                ),
                // LPopupMenuDivider(height: 1.h),
                // PopupMenuItem(
                //   onTap: controller.toReport,
                //   child: Text('举报', style: TextStyle(fontSize: 14.sp)),
                // ),
              ],
            ),
          ],
        ),
        body: Obx(
          () => ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
            shrinkWrap: true,
            reverse: true,
            itemBuilder: (BuildContext context, int index) {
              return Directionality(
                textDirection: controller.messages[index].role == ChatCompletionMessageRole.user ? TextDirection.rtl : TextDirection.ltr,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CachedImage(
                      width: 46.w,
                      height: 46.w,
                      borderRadius: BorderRadius.circular(8.r),
                      fit: BoxFit.cover,
                      imageUrl: controller.messages[index].role == ChatCompletionMessageRole.user ? "default_avatar.png".mine : controller.arg.logUrl,
                      assetUrl: controller.messages[index].role == ChatCompletionMessageRole.user ? "default_avatar.png".mine : null,
                    ),
                    8.horizontalSpace,
                    Expanded(
                      child: Wrap(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 240, 240, 241),
                              borderRadius: const BorderRadius.all(Radius.circular(15)).copyWith(
                                topLeft: controller.messages[index].role == ChatCompletionMessageRole.user ? const Radius.circular(15) : Radius.zero,
                                topRight: controller.messages[index].role == ChatCompletionMessageRole.user ? Radius.zero : const Radius.circular(15),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _getMsgStr(controller.messages[index]).isEmpty
                                    ? const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [SpinKitThreeBounce(color: Colors.white, size: 12)],
                                      )
                                    : Text(
                                        _getMsgStr(controller.messages[index]),
                                        textDirection: TextDirection.ltr,
                                      ),
                                5.verticalSpace,
                                if (controller.messages[index].role != ChatCompletionMessageRole.user && index != controller.messages.length - 1)
                                  InkWell(
                                    onTap: () {
                                      controller.copyText(_getMsgStr(controller.messages[index]));
                                      HandleTool.showAppToastText("复制成功");
                                    },
                                    child: Container(
                                      width: 30.w,
                                      height: 30.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30.r),
                                        color: const Color.fromARGB(255, 240, 240, 241),
                                      ),
                                      child: Icon(Icons.copy, size: 16.sp),
                                    ),
                                  )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            itemCount: controller.messages.length,
            separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10),
          ),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            5.verticalSpace,

            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //   child: TextField(
            //     controller: controller.textEditingController,
            //     decoration: InputDecoration(
            //       hintText: '尽情描述你的问题，告诉我吧~',
            //       border: GradientOutlineInputBorder(
            //         gradient: LinearGradient(colors: context.eTheme.gradientColors),
            //         borderRadius: const BorderRadius.all(Radius.circular(40)),
            //       ),
            //     ),
            //     onEditingComplete: controller.sendMessage,
            //   ),
            // ),

            Container(
              margin: EdgeInsets.only(top: 8.w, bottom: 10.h, right: 16.w, left: 16.w),
              height: 52.w,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color.fromRGBO(180, 153, 255, 0), Color.fromRGBO(90, 33, 255, 0.31)],
                ),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: TextField(
                controller: controller.textEditingController,
                decoration: InputDecoration(
                  hintText: '尽情描述你的问题，告诉我吧~',
                  hintStyle: TextStyle(fontSize: 15.sp, color: const Color.fromRGBO(178, 178, 178, 1)),
                  border: const GradientOutlineInputBorder(
                    gradient: LinearGradient(colors: [Colors.black, Colors.black]),
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                  ),
                  // 自定义渐变发送按钮
                  suffixIcon: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                          onTap: () {
                            controller.sendMessage();
                          },
                          child: Container(
                              margin: const EdgeInsets.only(right: 6),
                              width: 74.w,
                              height: 40.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(27.r), // 圆角27
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF58D6FF), // #58D6FF
                                    Color(0xFF9E60FF), // #9E60FF
                                    Color(0xFFEA7AE0), // #EA7AE0
                                  ],
                                ),
                              ),
                              child: Center(
                                  child: CommText(
                                text: "发送",
                                textColor: Colors.white,
                                fontSize: 18.sp,
                              )))),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: context.mediaQuery.padding.bottom),
            Obx(() => SizedBox(height: controller.keyboardHeight.value)),
          ],
        ),
      ),
    );
  }

  String _getMsgStr(ChatCompletionMessage msg) {
    return msg.content is ChatCompletionUserMessageContent ? (msg.content as ChatCompletionUserMessageContent).value.toString() : msg.content.toString();
  }
}
