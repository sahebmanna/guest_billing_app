import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/guest_controller.dart';

class GuestDetailsPage extends StatelessWidget {
  const GuestDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final guestController = Get.find<GuestController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Guest Details")),

      body: Obx(() {
        // LOADING

        if (guestController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // EMPTY

        if (guestController.billingData.value == null) {
          return const Center(child: Text("No Guest Data"));
        }

        final billing = guestController.billingData.value!;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(14),

          child: Column(
            children: [
              // =========================
              // MAIN BILL CARD
              // =========================
              Card(
                elevation: 5,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(16),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      // BILL NO
                      Row(
                        children: [
                          const Icon(Icons.receipt_long, color: Colors.blue),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              "Bill No : "
                              "${billing.billNo}",

                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // RESERVATION ID
                      Text(
                        "Reservation ID : "
                        "${billing.reservationId}",

                        style: const TextStyle(fontSize: 16),
                      ),

                      const SizedBox(height: 15),

                      // CHECK IN / OUT
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),

                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,

                                borderRadius: BorderRadius.circular(10),
                              ),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  const Text(
                                    "Check In",

                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  Text(billing.checkInDateTime),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),

                              decoration: BoxDecoration(
                                color: Colors.green.shade50,

                                borderRadius: BorderRadius.circular(10),
                              ),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  const Text(
                                    "Check Out",

                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  Text(billing.checkOutDateTime),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      // TABLE HEADER
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 10,
                        ),

                        decoration: BoxDecoration(
                          color: Colors.blue,

                          borderRadius: BorderRadius.circular(8),
                        ),

                        child: const Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Sl",

                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            Expanded(
                              flex: 3,

                              child: Text(
                                "Guest Name",

                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            Expanded(
                              flex: 2,

                              child: Text(
                                "Rate",

                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            Expanded(
                              flex: 2,

                              child: Text(
                                "Total",

                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // GUEST LIST
                      ...List.generate(billing.billingGuestList.length, (
                        index,
                      ) {
                        final guest = billing.billingGuestList[index];

                        return Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 10,
                          ),

                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey.shade300),
                            ),
                          ),

                          child: Row(
                            children: [
                              Expanded(child: Text("${index + 1}")),

                              Expanded(flex: 3, child: Text(guest.guestName)),

                              Expanded(
                                flex: 2,

                                child: Text(
                                  "₹ ${billing.payableChargePerGuest}",
                                ),
                              ),

                              Expanded(
                                flex: 2,

                                child: Text(
                                  "₹ ${billing.payableChargePerGuest}",
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                      const SizedBox(height: 25),

                      // TOTAL
                      Align(
                        alignment: Alignment.centerRight,

                        child: Text(
                          "Total ₹${billing.totalAmount}",

                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // TOTAL GUESTS
                      Text(
                        "Total Guests : "
                        "${billing.totalBillableGuests}",

                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // PAY NOW BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),

                  onPressed: () {},

                  child: const Text(
                    "PAY NOW",

                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
