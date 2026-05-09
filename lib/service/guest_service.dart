// import 'dart:convert';

// import 'package:http/http.dart' as http;

// import '../model/guest_model.dart';

// class GuestService {
//   static Future<List<GuestModel>> fetchGuests() async {
//     final response = await http.get(
//       Uri.parse(
//         "https://api.atithiaadhaar.com/api/BillingService/GetGuestBillingByReservationId/INDG77591498",
//       ),
//     );

//     print("STATUS CODE: ${response.statusCode}");
//     print("BODY: ${response.body}");
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       print("DECODED DATA: $data");
//       List guestList =
//           data['GuestBillingByReservationIdResponse']['BillingGuestList'];

//       return guestList.map((e) => GuestModel.fromJson(e)).toList();
//     } else {
//       throw Exception("Failed to load guests");
//     }
//   }
// }

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/guest_model.dart';

class GuestService {
  static Future<List<GuestModel>> fetchGuests() async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://api.atithiaadhaar.com/api/BillingService/GetGuestBillingByReservationId/INDG77591498",
        ),
      );

      print("STATUS CODE: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print("DECODED DATA: $data");

        // SAFE NULL CHECKING

        final responseData = data['GuestBillingByReservationIdResponse'];

        if (responseData == null) {
          return [];
        }

        final billingGuestList = responseData['BillingGuestList'];

        final amount = responseData['TSDPayableChargePerGuest'];

        if (billingGuestList == null) {
          return [];
        }

        // ENSURE IT IS A LIST

        if (billingGuestList is! List) {
          return [];
        }

        return billingGuestList.map<GuestModel>((e) {
          e['amount'] = amount.toString();
          return GuestModel.fromJson(e);
        }).toList();
      } else {
        throw Exception(
          "Failed to load guests. Status Code: ${response.statusCode}",
        );
      }
    } catch (e) {
      print("SERVICE ERROR: $e");
      rethrow;
    }
  }
}
