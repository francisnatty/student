// lib/providers/chat_provider.dart
import 'package:flutter/material.dart';
import 'package:student_centric_app/core/network/api_service.dart';
import 'package:student_centric_app/features/chats/models/chat_user.dart';

class ChatProvider with ChangeNotifier {
  List<ChatUser> _chats = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ChatUser> get chats => _chats;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

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

  void resetChats() {
    _chats = [];
    _errorMessage = null;
    notifyListeners();
  }
}
