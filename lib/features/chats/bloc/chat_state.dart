part of 'chat_bloc.dart';

enum ChatStatus { loading, error, success, initial }

class ChatState extends Equatable {
  final Failure? error;
  final GetChatHistoryModel? chats;
  final GetConversationModel? conversation;
  final ChatStatus status;

  const ChatState({
    this.error,
    required this.status,
    this.chats,
    this.conversation,
  });
  @override
  List<Object?> get props => [
        error,
        chats,
        status,
        conversation,
      ];

  ChatState copyWith(
      {Failure? error,
      GetChatHistoryModel? chats,
      ChatStatus? status,
      GetConversationModel? conversation}) {
    return ChatState(
        error: error ?? this.error,
        chats: chats ?? this.chats,
        status: status ?? this.status,
        conversation: conversation ?? this.conversation);
  }
}
