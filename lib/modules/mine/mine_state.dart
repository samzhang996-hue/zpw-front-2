import 'package:zpw/modules/main/model/user_info_bean.dart';
import 'package:zpw/utils/handle_tool.dart';

class MineState {
  late UserInfoBean userInfoBean;
  var headImage = '';
  MineState() {
    userInfoBean = UserInfoBean();
    headImage = HandleTool.instance.headImg;
  }
}
