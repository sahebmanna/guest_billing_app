class GuestModel {
  final String? guestId;
  final String? guestName;
  final String? amount;

  GuestModel({this.guestId, this.guestName, this.amount});

  factory GuestModel.fromJson(Map<String, dynamic> json) {
    return GuestModel(
      guestId: json['GuestId']?.toString(),

      guestName: json['GuestName']?.toString(),

      amount: json['amount']?.toString() ?? "0",
    );
  }
}
