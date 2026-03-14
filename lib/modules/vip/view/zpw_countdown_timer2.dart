import 'dart:async';

import 'package:flutter/material.dart';

import 'package:zpw/common/view/zpw_comm_text.dart';

class ZpwCountdownTimer2 extends StatefulWidget {
  final void Function()? onCountdownComplete; // 添加回调函数

  ZpwCountdownTimer2({this.onCountdownComplete});
  @override
  _ZpwCountdownTimerState createState() => _ZpwCountdownTimerState();
}

class _ZpwCountdownTimerState extends State<ZpwCountdownTimer2> {
  Duration duration = Duration(minutes: 9, seconds: 0, milliseconds: 0);
  Timer? timer;
  int milliseconds = 0;
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
      setState(() {
        if (duration.inMilliseconds > 0) {
          duration = duration - const Duration(milliseconds: 20);
          milliseconds = (60 - (duration.inMilliseconds / 1000 * 60).floor()) % 60;
        } else {
          timer.cancel();
          // 倒计时结束，执行回调并隐藏组件
          if (widget.onCountdownComplete != null) {
            widget.onCountdownComplete!();
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 31,
          height: 27,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 1,
              color: Color(0xffE00505)
            ),
            borderRadius: BorderRadius.circular(8)
          ),
          child: ZpwCountdownDigit(
            digit: duration.inMinutes.remainder(60).toString().padLeft(2, '0'),
            backgroundColor: Colors.transparent,
          ),
        ),
       Container(
           margin: EdgeInsets.only(left: 3,right: 3),
           child: ZpwCommText(text: ":",fontWeight: FontWeight.bold,fontSize: 20,textColor: Color(0xffE00505),)),
        Container(
          width: 31,
          height: 27,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  width: 1,
                  color: Color(0xffE00505)
              ),
              borderRadius: BorderRadius.circular(8)
          ),
          child: ZpwCountdownDigit(
            digit: duration.inSeconds.remainder(60).toString().padLeft(2, '0'),
            backgroundColor: Colors.transparent,
          ),
        ),
        Container(
            margin: EdgeInsets.only(left: 3,right: 3),
            child: ZpwCommText(text: ":",fontWeight: FontWeight.bold,fontSize: 20,textColor: Color(0xffE00505),)),
        Container(
          width: 31,
          height: 27,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                  width: 1,
                  color: Color(0xffE00505)
              ),
              borderRadius: BorderRadius.circular(8)
          ),
          child: ZpwCountdownDigit(
            digit: milliseconds.toString().padLeft(2, '0'),
            backgroundColor: Colors.transparent,
          ),
        ),
      ],
    );
  }
}

class ZpwCountdownDigit extends StatelessWidget {
  final String digit;
  final Color backgroundColor;

  ZpwCountdownDigit({required this.digit, required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child:Align(
        alignment: Alignment.center,
        child:  ZpwCommText(
          text: digit,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          textColor: Color(0xffE00505),
        ),
      )
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Countdown Timer'),
      ),
      body: Center(
        child: Container(
            width: 31,
            height: 27,
            child: ZpwCountdownTimer2()),
      ),
    ),
  ));
}