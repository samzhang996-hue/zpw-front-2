import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:keyboard_height_plugin/keyboard_height_plugin.dart';
import 'package:openai_dart/openai_dart.dart';
import '../../base/chat_ark_controller.dart';
import '../../model/smart_model.dart';

class ChatController extends GetxController {
  final SmartModel arg;

  final TextEditingController textEditingController = TextEditingController();

  final RxList<ChatCompletionMessage> messages = RxList([]);

  RxDouble keyboardHeight = 0.0.obs;

  final KeyboardHeightPlugin _keyboardHeightPlugin = KeyboardHeightPlugin();

  ChatController({
    required this.arg,
  }) {
    messages.add(ChatCompletionMessage.system(content: arg.description));
  }

  @override
  void onReady() {
    _keyboardHeightPlugin.onKeyboardHeightChanged((double height) {
      keyboardHeight.value = height;
    });
    super.onReady();
  }

  /// 发送消息
  void sendMessage() async {
    final text = textEditingController.text;
    if (text.isEmpty) return;
    textEditingController.clear();
    messages.insert(0, ChatCompletionMessage.user(content: ChatCompletionUserMessageContent.string(text)));

    final stream = ChatArkController.req(model: ChatCompletionModel.modelId(arg.thirdId), messages: messages.reversed.toList());
    String str = '';
    messages.insert(0, ChatCompletionMessage.assistant(content: str));

    await for (final res in stream) {
      str += res.choices.first.delta.content ?? '';
      messages.first = ChatCompletionMessage.assistant(content: str);
      messages.refresh();
    }
  }

  /// 清空消息
  void clearMessage() {
    // showConfirmDialog(
    //   title: '删除记录',
    //   message: '您确定要清空所有聊天记录吗? 删除对话记',
    //   onConfirm: () {
    /// 保留系统消息
    messages.value = messages.where((element) => element.role == ChatCompletionMessageRole.system).toList();
    messages.refresh();
    //   },
    // );
  }

  /// 复制文本
  void copyText(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }
}
