import 'package:get/get.dart';

import '../model/guest_model.dart';

import '../service/guest_service.dart';

class GuestController extends GetxController {
  RxBool isLoading = true.obs;

  Rxn<BillingResponseModel> billingData = Rxn<BillingResponseModel>();

  @override
  void onInit() {
    super.onInit();

    fetchGuests();
  }

  Future<void> fetchGuests() async {
    try {
      isLoading.value = true;

      final result = await GuestService.fetchGuests();

      billingData.value = result;
    } catch (e) {
      print("CONTROLLER ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
