import 'package:flutter/material.dart';
import 'package:zpw/base/zpw_base_widget.dart';
import 'package:zpw/common/zpw_style.dart';
import 'package:zpw/common/view/zpw_comm_text.dart';

class ZpwEmptyView extends StatefulWidget {
  late String imagePath;
  String? text;
  double marginTop;
  double viewHeight;
  bool isShowBtn;
  Function? clickLoadAction;
  ZpwEmptyView(
      {Key? key,
      this.imagePath = 'empty_box.png',
      this.text,
      this.viewHeight = 0.0,
      this.marginTop = 0,
      this.isShowBtn = false,
      this.clickLoadAction})
      : super(key: key);

  @override
  State<ZpwEmptyView> createState() => _ZpwEmptyPageState();
}

class _ZpwEmptyPageState extends State<ZpwEmptyView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double addHeight = widget.isShowBtn == true ? 45 : 0;
    return Container(
      alignment: Alignment.center,
      color: ZpwColorPlate.zpwThemeBgColor,
      width: zpwYScreenSize(context).width,
      height: widget.viewHeight > 0
          ? widget.viewHeight
          : zpwYScreenSize(context).height,
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
            ZpwCommText(
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
                      child: ZpwCommText(
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