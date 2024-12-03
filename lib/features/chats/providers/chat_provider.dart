// lib/providers/chat_provider.dart
import 'package:flutter/material.dart';
import 'package:student_centric_app/core/network/api_service.dart';
import 'package:student_centric_app/features/chats/models/chat_user.dart';
import 'package:student_centric_app/features/chats/models/conversation_model.dart';

class ChatProvider with ChangeNotifier {
  List<ChatUser> _chats = [];
  bool _isLoading = false;
  bool _sendMessageLoading = false;
  bool get sendMessageLoading => _sendMessageLoading;
  String? _errorMessage;
  String? _chatErrorMessage;
  String? get chatErrorMessage => _chatErrorMessage;

  List<ChatUser> get chats => _chats;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<ConversationData> _conversationData = [];
  List<ConversationData> get conversationData => _conversationData;

  String? _messageId = '';
  String? get messageId => _messageId;


  Future<void> fetchChats() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiService.instance.get("/datas/fetch/chats");

      if (response != null &&
          response.statusCode == 200 &&
          response.data['error'] == false) {
        final List<dynamic> data = response.data['data'];

        // Parse and filter the chats to include only those with firstName and lastName
        _chats = data
            .map((json) => ChatUser.fromJson(json))
            .where((chatUser) =>
                chatUser.firstName != null && chatUser.lastName != null)
            .toList();

        _errorMessage = null;
      } else {
        _errorMessage = response?.data['msg'] ?? 'Failed to fetch chats';
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> fetchConversation({required String messageId}) async {
    _isLoading = true;
    _chatErrorMessage = null;
    notifyListeners();
     debugPrint("fetch conversation called $messageId");
    try {
      final response = await ApiService.instance.get("/datas/fetch/one_on_one/conversations/$messageId");
      if (response != null &&
          response.statusCode == 200 &&
          response.data['error'] == false) {
        _conversationData.clear();
        final List<dynamic> data = response.data['data'];
        _conversationData = data
            .map((json) => ConversationData.fromJson(json))
            .toList();

        _chatErrorMessage = null;
      } else {
        _chatErrorMessage = response?.data['msg'] ?? 'Failed to fetch chats';
      }
    } catch (e) {
      _chatErrorMessage = 'An error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }



  // Future<void> initMessage({
  //   required String senderId,
  //   required String receiverId,
  //   required String content,
  //   required BuildContext context,
  //   bool showBanner = true,
  // }) async {
  //   _sendMessageLoading = true;
  //   notifyListeners();
  //
  //   final data = {
  //     "senderId":senderId,
  //     "receiverId": receiverId,
  //     "content": content,
  //     "type":"chat"
  //   };
  //
  //   final response = await ApiService.instance.post(
  //     "/datas/initiate/chat",
  //     data: data,
  //     isProtected: false,
  //     showBanner: showBanner,
  //   );
  //
  //   _sendMessageLoading = false;
  //   if (response != null && response.statusCode == 200) {
  //     final responseData = response.data;
  //     // Parse user data
  //     _messageId = responseData['data']['messageId'];
  //     fetchConversation(messageId: messageId??'');
  //     notifyListeners();
  //   } else {
  //     // Handle error (e.g., show a snackbar or dialog)
  //     notifyListeners();
  //   }
  // }


  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String messageId,
    required String content,
    required BuildContext context,
    bool showBanner = true,
  }) async {
    _sendMessageLoading = true;
    notifyListeners();

    debugPrint("message id is => $messageId");

    final data = {
      "messageId": messageId,
      "senderId":senderId,
      "receiverId": receiverId,
      "content": content,
      "type":"chat"
    };

    final response = await ApiService.instance.post(
      "/datas/fetch/chat",
      data: data,
      isProtected: true,
      showBanner: showBanner,
    );

    _sendMessageLoading = false;
    if (response != null && response.statusCode == 200) {
      fetchConversation(messageId: messageId);
      notifyListeners();
    } else {
      // Handle error (e.g., show a snackbar or dialog)
      notifyListeners();
    }
  }

  void resetChats() {
    _chats = [];
    _errorMessage = null;
    notifyListeners();
  }
}
