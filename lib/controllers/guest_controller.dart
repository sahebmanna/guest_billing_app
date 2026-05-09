import 'package:get/get.dart';

import '../model/guest_model.dart';
import '../service/guest_service.dart';

class GuestController extends GetxController {
  RxBool isLoading = true.obs;

  RxList<GuestModel> guestList = <GuestModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    fetchGuests();
  }

  Future<void> fetchGuests() async {
    try {
      print("API CALL STARTED");
      isLoading.value = true;

      final result = await GuestService.fetchGuests();
      print("TOTAL GUESTS: ${result.length}");
      print(result);
      guestList.value = result;
    } catch (e) {
      Get.snackbar("Error", e.toString());
      print("ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
