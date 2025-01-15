import 'package:flutter/material.dart';
import 'package:zpw/base/base_widget.dart';
import 'package:zpw/common/style.dart';
import 'package:zpw/common/view/comm_text.dart';

class EmptyView extends StatefulWidget {
  late String imagePath;
  String? text;
  double marginTop;
  double viewHeight;
  bool isShowBtn;
  Function? clickLoadAction;
  EmptyView(
      {Key? key,
      this.imagePath = 'empty_box.png',
      this.text,
      this.viewHeight = 0.0,
      this.marginTop = 0,
      this.isShowBtn = false,
      this.clickLoadAction})
      : super(key: key);

  @override
  State<EmptyView> createState() => _EmptyPageState();
}

class _EmptyPageState extends State<EmptyView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double addHeight = widget.isShowBtn == true ? 45 : 0;
    return Container(
      alignment: Alignment.center,
      color: ColorPlate.themeBgColor,
      width: yScreenSize(context).width,
      height: widget.viewHeight > 0
          ? widget.viewHeight
          : yScreenSize(context).height,
      child: SizedBox(
        height: 145 + addHeight,
        // color: Colors.cyan,
        child: Column(
          children: [
            Image.asset(
              widget.imagePath,
              width: 200,
              height: 120,
              fit: BoxFit.fitWidth,
            ),
            CommText(
              text: widget.text,
              fontSize: 14,
              textColor: const Color(0xffABB3B8),
            ),
            widget.isShowBtn == true
                ? GestureDetector(
                    onTap: () {
                      if (widget.clickLoadAction != null) {
                        widget.clickLoadAction!();
                      }
                    },
                    child: Container(
                      width: 100,
                      height: 30,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          color: const Color(0xff363739),
                          borderRadius: BorderRadius.circular(15)),
                      child: CommText(
                        text: "重新加载",
                        fontSize: 14,
                        textColor: const Color(0xffABB3B8),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
