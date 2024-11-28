// lib/providers/call_provider.dart
import 'package:flutter/material.dart';
import 'package:student_centric_app/core/network/api_service.dart';

class CallProvider with ChangeNotifier {
  String? _agoraToken;
  bool _isLoading = false;
  String? _errorMessage;

  String? get agoraToken => _agoraToken;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchAgoraToken(int userId, String channelName) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response =
          await ApiService.instance.post("/user/get/agoraToken", data: {
        "channelName": channelName,
        "user_id": userId,
      });

      if (response != null &&
          response.statusCode == 200 &&
          response.data['error'] == false) {
        _agoraToken = response.data['agoraToken'];
        _errorMessage = null;
      } else {
        _errorMessage = response?.data['msg'] ?? 'Failed to generate token';
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> initiateCall({
    required int callId,
    required int senderId,
    required int receiverId,
    required String type,
    required String channelName,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response =
          await ApiService.instance.post("/datas/initiate/call", data: {
        "callId": callId,
        "senderId": senderId,
        "receiverId": receiverId,
        "type": type,
        "channelName": channelName,
      });

      if (response != null &&
          response.statusCode == 200 &&
          response.data['error'] == false) {
        // Call initiated successfully
      } else {
        _errorMessage = response?.data['msg'] ?? 'Failed to initiate call';
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void resetToken() {
    _agoraToken = null;
    _errorMessage = null;
    notifyListeners();
  }
}
