class MessageModel {
  String? sender;
  String? text;
  bool? seen;
  DateTime? createdon;
  String? messageid;

  MessageModel(
    this.sender,
    this.text,
    this.seen,
    this.createdon,
    this.messageid,
  );

  MessageModel.fromMap(Map<String, dynamic> map) {
    sender = map["sender"];
    text = map["text"];
    seen = map["seen"];
    createdon = map["createdon"]?.toDate(); // Ensure `toDate()` is safely called
    messageid = map["messageid"];
  }

  Map<String, dynamic> toMap() {
    return {
      "sender": sender,
      "text": text,
      "seen": seen,
      "createdon": createdon,
      "messageid": messageid,
    };
  }
}
