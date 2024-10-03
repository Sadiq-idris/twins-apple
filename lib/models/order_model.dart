class OrderModel {
  const OrderModel({
    required this.userId,
    required this.userEmail,
    required this.product,
    required this.isDelivered,
    required this.howMany,
    required this.address,
  });
  final String userId;
  final String userEmail;
  final Map<String, dynamic> product;
  final bool isDelivered;
  final int howMany;
  final String address;

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "userEmail": userEmail,
      "product": product,
      "isDelivered": isDelivered,
      "howMany": howMany,
      "address": address,
    };
  }

  factory OrderModel.fromJson(Map json) {
    return OrderModel(
      userId: json["userId"],
      userEmail: json["userEmail"],
      product: json["product"],
      isDelivered: json["isDelivered"],
      howMany: json["howMany"],
      address: json["address"],
    );
  }
}
