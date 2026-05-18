import 'package:get/get.dart';

import '../model/guest_model.dart';

import '../service/guest_service.dart';

class GuestController extends GetxController {
  bool isLoading = true;

  GuestBillingResponse? billingData;

  @override
  void onInit() {
    super.onInit();

    fetchGuests();
  }

  Future<void> fetchGuests() async {
    try {
      isLoading = true;
      update();

      final result = await GuestService.fetchGuests();

      billingData = result;
      print(billingData?.guestBillingByReservationIdResponse?.billingGuestList);
    } catch (e) {
      print("CONTROLLER ERROR: $e");
    } finally {
      isLoading = false;
      update();
    }
  }
}
