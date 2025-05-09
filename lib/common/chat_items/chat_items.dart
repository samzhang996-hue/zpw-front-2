import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:zpw/common/list_item/list_item.dart';
import 'package:zpw/modules/chat/chat_view.dart';

import '../cached_image/cached_image.dart';
import '../future_layout_builder/future_layout_builder.dart';
import 'index_chat_controller.dart';

class ChatItems extends StatelessWidget {
  const ChatItems({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: IndexChatController(),
      builder: (controller) => FutureLayoutBuilder(
        future: controller.getData,
        builder: (_) => Obx(
          () => ListView.separated(
            padding: EdgeInsets.zero,
            separatorBuilder: (context, index) => 4.verticalSpace,
            itemBuilder: (BuildContext context, int index) {
              return ListItem(
                height: 70.h,
                color: Colors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 15.w),
                leading: CachedImage(
                  imageUrl: controller.data[index].logUrl,
                  width: 54.w,
                  height: 54.w,
                  borderRadius: BorderRadius.circular(54.r),
                  fit: BoxFit.cover,
                ),
                leadingEdgeInsets: EdgeInsets.only(right: 12.w),
                fieldType: FieldType.title,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.data[index].name,
                      style: TextStyle(fontSize: 16.sp, color: Colors.black, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      controller.data[index].description,
                      style: TextStyle(fontSize: 12.sp, color: const Color.fromRGBO(127, 127, 127, 1)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                onTap: () {
                  Get.to(() => ChatView(arg: controller.data[index]));
                },
              );
            },
            itemCount: controller.data.length,
          ),
        ),
      ),
    );
  }
}
