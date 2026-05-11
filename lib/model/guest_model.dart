class GuestModel {
  final String guestId;
  final String guestName;

  GuestModel({required this.guestId, required this.guestName});

  factory GuestModel.fromJson(Map<String, dynamic> json) {
    return GuestModel(
      guestId: json['GuestId']?.toString() ?? "",

      guestName: json['GuestName']?.toString() ?? "",
    );
  }
}

// BILLING RESPONSE MODEL

class BillingResponseModel {
  final String billNo;

  final String reservationId;

  final String checkInDateTime;

  final String checkOutDateTime;

  final int totalBillableGuests;

  final String totalAmount;

  final String payableChargePerGuest; //amount

  final List<GuestModel> billingGuestList;

  BillingResponseModel({
    required this.billNo,

    required this.reservationId,

    required this.checkInDateTime,

    required this.checkOutDateTime,

    required this.totalBillableGuests,

    required this.totalAmount,

    required this.payableChargePerGuest,

    required this.billingGuestList,
  });

  factory BillingResponseModel.fromJson(Map<String, dynamic> json) {
    final guestList = json['BillingGuestList'] as List;

    return BillingResponseModel(
      billNo: json['BillNo']?.toString() ?? "",

      reservationId: json['ReservationId']?.toString() ?? "",

      checkInDateTime: json['CheckInDateTime']?.toString() ?? "",

      checkOutDateTime: json['CheckOutDateTime']?.toString() ?? "",

      totalBillableGuests: json['TotalBillableGuests'] ?? 0,

      totalAmount: json['TotalBillableGuestsPrice']?.toString() ?? "0",

      payableChargePerGuest:
          json['TSDPayableChargePerGuest']?.toString() ?? "0",

      billingGuestList: guestList.map((e) => GuestModel.fromJson(e)).toList(),
    );
  }
}
