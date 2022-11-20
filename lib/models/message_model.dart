class MessageModel{
  String? date;
  String? message;
  String? senderId;
  String? receiverId;
  String? imageMessage;

  MessageModel({
    required this.date,
    required this.message,
    required this.senderId,
    required this.receiverId,
    required this.imageMessage,

  });

  MessageModel.formJson(Map <String , dynamic>? json){
    date=json!['data'];
    message=json['message'];
    senderId=json['senderId'];
    receiverId=json['receiverId'];
    imageMessage=json['imageMessage'];

  }

  Map <String , dynamic> toMap(){
    return {
      'date' : date,
      'message' : message,
      'senderId' : senderId,
      'receiverId' : receiverId,
      'imageMessage' : imageMessage,

    };
  }

}

