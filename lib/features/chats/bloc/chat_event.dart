part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {}

class GetChatHistoryEvent extends ChatEvent {
  @override
  List<Object> get props => [];
}

class GetConversationEvent extends ChatEvent {
  final String messageId;
  GetConversationEvent({required this.messageId});
  @override
  List<Object> get props => [];
}
