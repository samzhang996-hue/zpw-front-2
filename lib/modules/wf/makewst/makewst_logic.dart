import 'dart:async';

import 'package:get/get.dart';
import 'package:zpw/base/base_getx_controller.dart';
import 'package:zpw/network/api/network_api.dart';
import 'package:zpw/utils/log_utils.dart';
import 'dart:convert';
import 'makewst_state.dart';

class MakewstLogic extends BaseGetxController {
  final MakewstState state = MakewstState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    var map = Get.arguments;
    if (map != null) {
      state.funcValue.value = map["funcValue"] ?? "";
      state.funcId.value = map["funcId"] ?? 0;
      update();
    }
    photoRecord(true);
    defTimbreVO();
  }

  titleIndexState(int index) {
    state.titleIndex.value = index;
    state.title.value = state.itemTitles[index]["title"];
    update();
  }

  fgIndexState(int index) {
    state.fgIndex.value = index;
    state.name.value = state.hfList[index]["name"];
    update();
  }

  isAddState(bool index) {
    state.isAdd.value = index;
    update();
  }

  Timer? _pollingTimer;

  // 开始轮询
  void startPolling() {
    _pollingTimer ??= Timer.periodic(const Duration(seconds: 10), (timer) {
      photoRecord(false);
    });
  }

  // 停止轮询
  void stopPolling() {
    if (_pollingTimer != null) {
      _pollingTimer!.cancel();
      _pollingTimer = null;
    }
  }

  photoRecord(bool rush) {
    Map<String, dynamic> dataMap = {
      "pageIndex": 1,
      "pageSize": 100,
      "apiType": 6,
    };
    get(Api.photoRecord, isShowProgress: rush, params: dataMap, success: (isSuccess, code, message, results) {
      if (isSuccess == true && results.isNotEmpty) {
        Map data = results.first as Map;
        state.records.value = data["records"];
        update();
        bool shouldContinuePolling = state.records.value.any((record) => record['worksStatus'] == 1 || record['worksStatus'] == 2);
        if (!shouldContinuePolling) {
          stopPolling();
        } else {
          startPolling();
        }
        Log.d("get----${state.records}");
      }
    });
  }

  addPhotoRecord() {
    final valueJsonMap = {
      "title": state.itemTitles[state.titleIndex.value]["title"],
      "name": state.hfList[state.fgIndex.value]["name"],
    };
    final String valueJsonString = jsonEncode(valueJsonMap);
    final params = {
      "funcId": state.funcId.value,
      "novel": state.funcValue.value,
      "width": state.itemTitles[state.titleIndex.value]["width"],
      "height": state.itemTitles[state.titleIndex.value]["height"],
      "prompt": state.hfList[state.fgIndex.value]["voiceType"] ?? "",
      "valueJson": valueJsonString
    };

    Post(Api.addPhotoRecord, params: params, success: (isSuccess, code, message, results) {
      if (isSuccess == true && results.isNotEmpty) {
        Log.d("list----${results.first}");
        photoRecord(true);
      }
    });
  }

  defTimbreVO() {
    get(Api.defTimbreVO, success: (isSuccess, code, message, results) {
      if (isSuccess == true && results.isNotEmpty) {
        List<Map<String, dynamic>> dataList = results.cast<Map<String, dynamic>>();
        state.hfList.value = dataList;
        update();
      }
    });
  }

  remakePhotoRecord(int id) {
    get("${Api.remakePhotoRecord}?id=$id", isShowProgress: true, success: (isSuccess, code, message, results) {
      if (isSuccess == true && results.isNotEmpty) {
        photoRecord(true);
        update();
      }
    });
  }
}
