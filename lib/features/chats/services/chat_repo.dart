import 'package:dartz/dartz.dart';
import 'package:student_centric_app/config/service_locator.dart';
import 'package:student_centric_app/core/utils/type_def.dart';
import 'package:student_centric_app/features/chats/services/chat_service.dart';

import '../models/get_chat_history.dart';
import '../models/get_conversation_model.dart';

abstract class ChatRepo {
  ApiResult<GetChatHistoryModel> getChatHistory();
  ApiResult<GetConversationModel> getConversation({required String messageId});
}

class ChatRepoImpl extends ChatRepo {
  final chatService = Di.getIt<ChatService>();
  @override
  ApiResult<GetChatHistoryModel> getChatHistory() async {
    final response = await chatService.chatHistory();
    if (response.success!) {
      return Right(response.data!);
    } else {
      return Left(response.failure!);
    }
  }

  @override
  ApiResult<GetConversationModel> getConversation(
      {required String messageId}) async {
    final response = await chatService.getConversation(messageid: messageId);
    if (response.success!) {
      return Right(response.data!);
    } else {
      return Left(response.failure!);
    }
  }
}
