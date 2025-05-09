import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zpw/common/constant.dart';

class GameplayBanner extends StatefulWidget {
  const GameplayBanner({super.key, this.onTap});
  final void Function(int index)? onTap;
  @override
  State<GameplayBanner> createState() => _GameplayBannerState();
}

class _GameplayBannerState extends State<GameplayBanner> {
  final _list = [
    ("banner_01.png".gameplay),
    ("banner_02.png".gameplay),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 146.w,
      child: Swiper(
        itemCount: _list.length,
        autoplay: true,
        itemBuilder: (context, index) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {
                widget.onTap?.call(index);
              },
              behavior: HitTestBehavior.opaque,
              child: Image.asset(_list[index], height: 146.w),
            ),
          );
        },
        pagination: SwiperCustomPagination(
          builder: (context, config) {
            return Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 20.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(_list.length, (index) {
                    return Container(
                      width: index == config.activeIndex ? 8.w : 6.w,
                      height: index == config.activeIndex ? 8.w : 6.w,
                      margin: EdgeInsets.only(bottom: 8.w),
                      decoration: BoxDecoration(
                        color: index == config.activeIndex ? Colors.white : Colors.white.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
