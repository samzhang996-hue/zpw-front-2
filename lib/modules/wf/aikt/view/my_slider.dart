import 'package:flutter/material.dart';
import 'package:zpw/common/style.dart';
import 'package:zpw/common/view/comm_text.dart'; // 确保这个路径是正确的
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef ValueChangedCallback = void Function(double newValue);

class MySlider extends StatefulWidget {
  final ValueChangedCallback onValueChanged;
  MySlider({required this.onValueChanged});

  @override
  _MySliderState createState() => _MySliderState();
}

class _MySliderState extends State<MySlider> {
  double _value = 0.1; // 初始值

  void _onChanged(double value) {
    setState(() {
      _value = value;
    });
    // 调用父组件传递的回调函数
    widget.onValueChanged(_value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 40.w, // 增加高度以容纳圆形标记
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4.w, // 横线的高度
              activeTrackColor: ColorPlate.themeColor, // 横线的颜色
              inactiveTrackColor: Color(0xffE5E5E5), // 横线的背景色
              // thumbShape: RoundSliderThumbShape(
              //   enabledThumbRadius: 10.w, // 滑块的大小
              // ),
              // overlayShape: RoundSliderOverlayShape(
              //   overlayRadius: 15.w, // 滑块点击时的涟漪效果大小
              // ),
              // 自定义标记形状
              tickMarkShape: RoundSliderTickMarkShape(
                tickMarkRadius: 6.w, // 圆形标记的大小
              ),
              thumbColor: Color(0xff7FE7F9), // 滑块的颜色
              activeTickMarkColor: ColorPlate.themeColor, // 选中标记的颜色
              inactiveTickMarkColor: Color(0xffE5E5E5), // 未选中标记的颜色
            ),
            child: Slider(
              value: _value,
              min: 0.1,
              max: 1.0,
              divisions: 4, // 标记数量
              onChanged: _onChanged,
              // label: _value.toStringAsFixed(1), // 显示当前值，保留一位小数
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CommText(
              text: "100%",
              fontSize: 12.sp,
              textColor: Color(0xffB2B2B2),
              fontWeight: FontWeight.w600,
            ),
            CommText(
              text: "110%",
              fontSize: 12.sp,
              textColor: Color(0xffB2B2B2),
              fontWeight: FontWeight.w600,
            ),
            CommText(
              text: "125%",
              fontSize: 12.sp,
              textColor: Color(0xffB2B2B2),
              fontWeight: FontWeight.w600,
            ),
            CommText(
              text: "150%",
              fontSize: 12.sp,
              textColor: Color(0xffB2B2B2),
              fontWeight: FontWeight.w600,
            ),
            CommText(
              text: "200%",
              fontSize: 12.sp,
              textColor: Color(0xffB2B2B2),
              fontWeight: FontWeight.w600,
            ),
          ],
        )
      ],
    );
  }
}