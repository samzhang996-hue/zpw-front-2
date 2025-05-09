import 'package:openai_dart/openai_dart.dart';

/////////////////////////////////////////////////////////////////////////
///
/// All rights reserved.
///
/// author: Spicely
///
/// Summary: 火山引擎智能体聊天控制器
///
/// Date: 2024年10月30日 18:01:32 Wednesday
///
//////////////////////////////////////////////////////////////////////////

class ChatArkController {
  static final client = OpenAIClient(
    apiKey: 'a5c460df-d9bd-4b90-ae64-e71bf6c46db6',
    baseUrl: 'https://ark.cn-beijing.volces.com/api/v3/bots',
  );

  static Stream<CreateChatCompletionStreamResponse> req({
    required ChatCompletionModel model,
    required List<ChatCompletionMessage> messages,
  }) {
    return client.createChatCompletionStream(request: CreateChatCompletionRequest(model: model, messages: messages));
  }
}
