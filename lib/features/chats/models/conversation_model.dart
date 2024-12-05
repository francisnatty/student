class ConversationModel {
  List<ConversationData>? data;
  bool? error;
  String? msg;

  ConversationModel({this.data, this.error, this.msg});

  ConversationModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ConversationData>[];
      json['data'].forEach((v) {
        data!.add(ConversationData.fromJson(v));
      });
    }
    error = json['error'];
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['error'] = error;
    data['msg'] = msg;
    return data;
  }
}

class ConversationData {
  //int? id;
  //Null? callId;
 // String? messageId;
  String? senderId;
  String? receiverId;
  String? message;
  //String? type;
  //String? status;
  //Null? channelName;
  DateTime? createdAt;
  //String? updatedAt;

  ConversationData(
      {
        //this.id,
      //this.callId,
     // this.messageId,
      this.senderId,
      this.receiverId,
      this.message,
     // this.type,
     // this.status,
      // this.channelName,
      this.createdAt,
      //this.updatedAt
      });

  ConversationData.fromJson(Map<String, dynamic> json) {
   // id = json['id'];
    // callId = json['callId'];
   // messageId = json['messageId'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    message = json['message'];
    //type = json['type'];
   // status = json['status'];
    // channelName = json['channelName'];
    //createdAt = json['created_at'];
    createdAt= DateTime.parse(json['createdAt']);
   // updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    //data['id'] = id;
    //data['callId'] = callId;
   // data['messageId'] = messageId;
    data['senderId'] = senderId;
    data['receiverId'] = receiverId;
    data['message'] = message;
   // data['type'] = type;
   // data['status'] = status;
    //data['channelName'] = channelName;
    data['created_at'] = createdAt;
   // data['updated_at'] = updatedAt;
    return data;
  }
}
