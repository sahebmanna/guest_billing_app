/* class GuestModel {
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
*/

// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

// GuestBillingResponse welcomeFromJson(String str) => GuestBillingResponse.fromJson(json.decode(str));
// String welcomeToJson(GuestBillingResponse data) => json.encode(data.toJson());

GuestBillingResponse guestBillingResponseFromJson(String str) =>
    GuestBillingResponse.fromJson(json.decode(str));

String guestBillingResponseToJson(GuestBillingResponse data) =>
    json.encode(data.toJson());

class GuestBillingResponse {
  int? status;
  String? message;
  GuestBillingByReservationIdResponse? guestBillingByReservationIdResponse;

  GuestBillingResponse({
    this.status,
    this.message,
    this.guestBillingByReservationIdResponse,
  });

  factory GuestBillingResponse.fromJson(Map<String, dynamic> json) =>
      GuestBillingResponse(
        status: json["Status"],
        message: json["Message"],
        guestBillingByReservationIdResponse:
            json["GuestBillingByReservationIdResponse"] == null
            ? null
            : GuestBillingByReservationIdResponse.fromJson(
                json["GuestBillingByReservationIdResponse"],
              ),
      );

  Map<String, dynamic> toJson() => {
    "Status": status,
    "Message": message,
    "GuestBillingByReservationIdResponse": guestBillingByReservationIdResponse
        ?.toJson(),
  };
}

class GuestBillingByReservationIdResponse {
  final String? billNo;
  final String? invoiceNo;
  final String? reservationId;
  final String? propertyCode;
  final String? checkInDateTime;
  final String? checkOutDateTime;
  final int? totalBillableGuests;
  final int? totalGuests;
  final String? chargeForTsdPaidMode;
  final bool? isPropertyGstApplicable;
  final num? tsdPayableChargePerGuest;
  final bool? isTsdChargePaid;
  final num? totalBillableGuestsPrice;
  final PropertyDetailsForBilling? propertyDetailsForBilling;
  final List<BillingGuestList> billingGuestList;

  GuestBillingByReservationIdResponse({
    this.billNo,
    this.invoiceNo,
    this.reservationId,
    this.propertyCode,
    this.checkInDateTime,
    this.checkOutDateTime,
    this.totalBillableGuests,
    this.totalGuests,
    this.chargeForTsdPaidMode,
    this.isPropertyGstApplicable,
    this.tsdPayableChargePerGuest,
    this.isTsdChargePaid,
    this.totalBillableGuestsPrice,
    this.propertyDetailsForBilling,
    this.billingGuestList = const [], //change here
  });

  factory GuestBillingByReservationIdResponse.fromJson(
    Map<String, dynamic> json,
  ) => GuestBillingByReservationIdResponse(
    billNo: json["BillNo"],
    invoiceNo: json["InvoiceNo"],
    reservationId: json["ReservationId"],
    propertyCode: json["PropertyCode"],
    checkInDateTime: json["CheckInDateTime"],
    checkOutDateTime: json["CheckOutDateTime"],
    totalBillableGuests: json["TotalBillableGuests"],
    totalGuests: json["TotalGuests"],
    chargeForTsdPaidMode: json["ChargeForTSDPaidMode"],
    isPropertyGstApplicable: json["IsPropertyGstApplicable"],
    tsdPayableChargePerGuest: json["TSDPayableChargePerGuest"],
    isTsdChargePaid: json["IsTSDChargePaid"],
    totalBillableGuestsPrice: json["TotalBillableGuestsPrice"],
    propertyDetailsForBilling: json["PropertyDetailsForBilling"] == null
        ? null
        : PropertyDetailsForBilling.fromJson(json["PropertyDetailsForBilling"]),
    // billingGuestList: List<BillingGuestList>.from(
    //   json["BillingGuestList"]!.map((x) => BillingGuestList.fromJson(x)),
    // ),
    billingGuestList: json["BillingGuestList"] == null
        ? []
        : List<BillingGuestList>.from(
            (json["BillingGuestList"] as List).map(
              (x) => BillingGuestList.fromJson(x),
            ),
          ),
  );

  Map<String, dynamic> toJson() => {
    "BillNo": billNo,
    "InvoiceNo": invoiceNo,
    "ReservationId": reservationId,
    "PropertyCode": propertyCode,
    "CheckInDateTime": checkInDateTime,
    "CheckOutDateTime": checkOutDateTime,
    "TotalBillableGuests": totalBillableGuests,
    "TotalGuests": totalGuests,
    "ChargeForTSDPaidMode": chargeForTsdPaidMode,
    "IsPropertyGstApplicable": isPropertyGstApplicable,
    "TSDPayableChargePerGuest": tsdPayableChargePerGuest,
    "IsTSDChargePaid": isTsdChargePaid,
    "TotalBillableGuestsPrice": totalBillableGuestsPrice,
    "PropertyDetailsForBilling": propertyDetailsForBilling?.toJson(),
    "BillingGuestList": List<dynamic>.from(
      billingGuestList.map((x) => x.toJson()),
    ),
  };
}

class BillingGuestList {
  final String? guestId;
  final String? guestName;
  final int? age;
  final String? sex;
  final String? emailId;
  final String? primaryContactNo;
  final dynamic reservationId;
  final dynamic propertyCode;

  BillingGuestList({
    this.guestId,
    this.guestName,
    this.age,
    this.sex,
    this.emailId,
    this.primaryContactNo,
    this.reservationId,
    this.propertyCode,
  });

  factory BillingGuestList.fromJson(Map<String, dynamic> json) =>
      BillingGuestList(
        guestId: json["GuestId"],
        guestName: json["GuestName"],
        age: json["Age"],
        sex: json["Sex"],
        emailId: json["EmailId"],
        primaryContactNo: json["PrimaryContactNo"],
        reservationId: json["ReservationId"],
        propertyCode: json["PropertyCode"],
      );

  Map<String, dynamic> toJson() => {
    "GuestId": guestId,
    "GuestName": guestName,
    "Age": age,
    "Sex": sex,
    "EmailId": emailId,
    "PrimaryContactNo": primaryContactNo,
    "ReservationId": reservationId,
    "PropertyCode": propertyCode,
  };
}

class PropertyDetailsForBilling {
  final String? propertyCode;
  final String? propertyName;
  final String? propertyType;
  final String? emailId;
  final String? mobileNo;
  final String? fullAddress;
  final String? cityTown;
  final String? postCode;
  final int? propertyStarRating;
  final dynamic chargeForTsdPaidMode;
  final bool? isPropertyGstApplicable;
  final String? stateCode;
  final String? stateName;
  final dynamic districtCommissionerateName;
  final dynamic divisionSubDivisionName;
  final dynamic policeStationName;

  PropertyDetailsForBilling({
    this.propertyCode,
    this.propertyName,
    this.propertyType,
    this.emailId,
    this.mobileNo,
    this.fullAddress,
    this.cityTown,
    this.postCode,
    this.propertyStarRating,
    this.chargeForTsdPaidMode,
    this.isPropertyGstApplicable,
    this.stateCode,
    this.stateName,
    this.districtCommissionerateName,
    this.divisionSubDivisionName,
    this.policeStationName,
  });

  factory PropertyDetailsForBilling.fromJson(Map<String, dynamic> json) =>
      PropertyDetailsForBilling(
        propertyCode: json["PropertyCode"],
        propertyName: json["PropertyName"],
        propertyType: json["PropertyType"],
        emailId: json["EmailId"],
        mobileNo: json["MobileNo"],
        fullAddress: json["FullAddress"],
        cityTown: json["CityTown"],
        postCode: json["PostCode"],
        propertyStarRating: json["PropertyStarRating"],
        chargeForTsdPaidMode: json["ChargeForTSDPaidMode"],
        isPropertyGstApplicable: json["IsPropertyGstApplicable"],
        stateCode: json["StateCode"],
        stateName: json["StateName"],
        districtCommissionerateName: json["DistrictCommissionerateName"],
        divisionSubDivisionName: json["DivisionSubDivisionName"],
        policeStationName: json["PoliceStationName"],
      );

  Map<String, dynamic> toJson() => {
    "PropertyCode": propertyCode,
    "PropertyName": propertyName,
    "PropertyType": propertyType,
    "EmailId": emailId,
    "MobileNo": mobileNo,
    "FullAddress": fullAddress,
    "CityTown": cityTown,
    "PostCode": postCode,
    "PropertyStarRating": propertyStarRating,
    "ChargeForTSDPaidMode": chargeForTsdPaidMode,
    "IsPropertyGstApplicable": isPropertyGstApplicable,
    "StateCode": stateCode,
    "StateName": stateName,
    "DistrictCommissionerateName": districtCommissionerateName,
    "DivisionSubDivisionName": divisionSubDivisionName,
    "PoliceStationName": policeStationName,
  };
}
