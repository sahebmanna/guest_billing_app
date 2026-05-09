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

        if (guestController.guestList.isEmpty) {
          return const Center(child: Text("No Guest Data"));
        }

        // TOTAL AMOUNT

        double totalAmount = 0;

        for (var guest in guestController.guestList) {
          totalAmount += double.tryParse(guest.amount ?? "0") ?? 0;
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,

          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),

              child: DataTable(
                border: TableBorder.all(color: Colors.grey.shade400),

                headingRowColor: WidgetStateProperty.all(Colors.grey.shade300),

                columns: const [
                  DataColumn(
                    label: Text(
                      "Sl No.",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  DataColumn(
                    label: Text(
                      "Guest Name",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  DataColumn(
                    label: Text(
                      "ID No.",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  DataColumn(
                    label: Text(
                      "Amount",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],

                rows: [
                  // GUEST ROWS
                  ...List.generate(guestController.guestList.length, (index) {
                    final guest = guestController.guestList[index];

                    return DataRow(
                      cells: [
                        DataCell(Text("${index + 1}")),

                        DataCell(
                          SizedBox(
                            width: 180,

                            child: Text(guest.guestName ?? ""),
                          ),
                        ),

                        DataCell(Text(guest.guestId ?? "")),

                        DataCell(Text("₹ ${guest.amount ?? ""}")),
                      ],
                    );
                  }),

                  // TOTAL ROW
                  DataRow(
                    color: WidgetStateProperty.all(Colors.grey.shade200),

                    cells: [
                      const DataCell(Text("")),

                      const DataCell(
                        Text(
                          "Total",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),

                      const DataCell(Text("")),

                      DataCell(
                        Text(
                          "₹ $totalAmount",

                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
