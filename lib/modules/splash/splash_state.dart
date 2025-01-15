import 'package:get/get.dart';

import 'model/login_entity.dart';

class SplashState {
  late LoginEntity loginEntity;
  late RxMap<String,dynamic> configData;
  SplashState() {
    ///Initialize variables
    loginEntity=LoginEntity();
  }
}
