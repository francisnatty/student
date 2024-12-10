import 'package:student_centric_app/features/chats/models/get_conversation_model.dart';

import '../../../config/service_locator.dart';
import '../../../core/api/api.dart';
import '../../../core/storage/local_storage.dart';
import '../models/get_chat_history.dart';

abstract class ChatService {
  Future<ApiResponse<GetChatHistoryModel>> chatHistory();
  Future<ApiResponse<GetConversationModel>> getConversation(
      {required String messageid});
}

class ChatServiceImpl extends ChatService {
  final apiClient = Di.getIt<ApiClient>();
  final localStorage = Di.getIt<LocalStorage>();

  @override
  Future<ApiResponse<GetChatHistoryModel>> chatHistory() async {
    String? token = await localStorage.getAcessToken();
    apiClient.setToken(token!);

    final response = await apiClient.request(
        path: 'datas/fetch/chats',
        method: MethodType.get,
        fromJsonT: (json) => GetChatHistoryModel.fromJson(json));

    return response;
  }

  @override
  Future<ApiResponse<GetConversationModel>> getConversation(
      {required String messageid}) async {
    String? token = await localStorage.getAcessToken();
    apiClient.setToken(token!);
    final response = await apiClient.request(
        path: 'datas/fetch/one_on_one/conversations/$messageid',
        method: MethodType.get,
        fromJsonT: (json) => GetConversationModel.fromJson(json));

    return response;
  }
}
