class Message {
  final String productID;
  final String senderID;
  final String receiverID;
  final String timestamp;
  final String message;

  Message({
    required this.productID,
    required this.senderID,
    required this.receiverID,
    required this.timestamp,
    required this.message,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'receiverID': receiverID,
      'timestamp': timestamp,
      'productID': productID,
      'message': message,
    };
  }
}
