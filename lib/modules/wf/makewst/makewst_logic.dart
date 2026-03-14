import 'dart:async';

import 'package:get/get.dart';
import 'package:zpw/base/zpw_base_getx_controller.dart';
import 'package:zpw/network/api/zpw_network_api.dart';
import 'package:zpw/utils/zpw_log_utils.dart';
import 'dart:convert';
import 'makewst_state.dart';

class MakewstZpwLogic extends ZpwBaseGetxController {
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
    Map<String, dynamic> dataMap = {"pageIndex": 1, "pageSize": 100, "apiType": 6, "sortType": 1};
    get(ZpwApi.zpwPhotoRecord, isShowProgress: rush, params: dataMap, success: (isSuccess, code, message, results) {
      if (isSuccess == true && results.isNotEmpty) {
        Map data = results.first as Map;
        state.records.value = data["records"];
        ZpwLog.d("get----${state.records}");
        update();
        bool shouldContinuePolling = state.records.value.any((record) => (record['worksStatus'] == 0 || record['worksStatus'] == 1));
        ZpwLog.d("msg1111---$shouldContinuePolling");
        if (!shouldContinuePolling) {
          stopPolling();
        } else {
          startPolling();
        }
        ZpwLog.d("get----${state.records.value}");
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

    Post(ZpwApi.zpwAddPhotoRecord, params: params, success: (isSuccess, code, message, results) {
      if (isSuccess == true && results.isNotEmpty) {
        ZpwLog.d("list----${results.first}");
        photoRecord(true);
      }
    });
  }

  defTimbreVO() {
    get(ZpwApi.zpwDefTimbreVO, success: (isSuccess, code, message, results) {
      if (isSuccess == true && results.isNotEmpty) {
        List<Map<String, dynamic>> dataList = results.cast<Map<String, dynamic>>();
        state.hfList.value = dataList;
        update();
      }
    });
  }

  remakePhotoRecord(int id) {
    get("${ZpwApi.zpwRemakePhotoRecord}?id=$id", isShowProgress: true, success: (isSuccess, code, message, results) {
      if (isSuccess == true && results.isNotEmpty) {
        photoRecord(true);
        update();
      }
    });
  }
}
