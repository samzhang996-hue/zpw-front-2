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
          height: 20.w,
          child: Slider(
            value: _value,
            min: 0.1,
            max: 1.0,
            divisions: 4, // 注意：这里应该是9，因为你想要在0.1到1.0之间均匀分布9个标记（尽管这不影响比例值的显示）
            onChanged: _onChanged,
            label: _value.toStringAsFixed(1), // 显示当前值，保留一位小数
            activeColor: ColorPlate.themeColor,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CommText(text: "100%",fontSize: 12.sp,textColor: Color(0xffB2B2B2),fontWeight: FontWeight.w600,),
            CommText(text: "110%",fontSize: 12.sp,textColor: Color(0xffB2B2B2),fontWeight: FontWeight.w600,),
            CommText(text: "125%",fontSize: 12.sp,textColor: Color(0xffB2B2B2),fontWeight: FontWeight.w600,),
            CommText(text: "150%",fontSize: 12.sp,textColor: Color(0xffB2B2B2),fontWeight: FontWeight.w600,),
            CommText(text: "200%",fontSize: 12.sp,textColor: Color(0xffB2B2B2),fontWeight: FontWeight.w600,),
          ],
        )
      ],
    );
  }
}