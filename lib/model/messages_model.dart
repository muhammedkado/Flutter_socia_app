class MessagesModel {
  String? text;
  String? sederId;
  String? receiverId;
  String? dateTime;

  MessagesModel({
    required this.text,
    required this.receiverId,
    required this.dateTime,
    required this.sederId,
  });

  MessagesModel.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    receiverId = json['receiverId'];
    dateTime = json['dateTime'];
    sederId = json['sederId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'sederId': sederId,
      'dateTime': dateTime,
      'text': text,
      'receiverId': receiverId,
    };
  }
}
