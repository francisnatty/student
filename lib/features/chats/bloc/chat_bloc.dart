import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:student_centric_app/config/service_locator.dart';
import 'package:student_centric_app/features/chats/models/get_chat_history.dart';
import 'package:student_centric_app/features/chats/services/chat_repo.dart';

import '../../../core/api/api.dart';
import '../models/get_conversation_model.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final chatRepo = Di.getIt<ChatRepo>();
  ChatBloc() : super(const ChatState(status: ChatStatus.initial)) {
    on<GetChatHistoryEvent>(_fetchChatHistory);
    on<GetConversationEvent>(_fetchConversations);
  }

  Future<void> _fetchChatHistory(
      GetChatHistoryEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(status: ChatStatus.loading));
    final result = await chatRepo.getChatHistory();
    result.fold((failure) {
      emit(state.copyWith(status: ChatStatus.error, error: failure));
    }, (chatsHistory) async {
      emit(
        state.copyWith(
          status: ChatStatus.success,
          chats: chatsHistory,
        ),
      );
    });
  }

  Future<void> _fetchConversations(
      GetConversationEvent event, Emitter<ChatState> emit) async {
    emit(state.copyWith(status: ChatStatus.loading));
    final result = await chatRepo.getConversation(messageId: event.messageId);
    result.fold((failure) {
      emit(state.copyWith(status: ChatStatus.error, error: failure));
    }, (conversations) async {
      emit(
        state.copyWith(status: ChatStatus.success, conversation: conversations),
      );
    });
  }
}
