import 'dart:ffi';

import 'package:electric_app/service/subscription_service.dart';
import 'package:flutter/material.dart';

class SubscriptionCard extends StatelessWidget {
  final String title;
  final String status;
  final double price;
  final VoidCallback? onActivated;
  final String? userid;

  const SubscriptionCard({
    super.key,
    required this.title,
    required this.status,
    required this.price,
    this.onActivated,
    required this.userid,
  });

  Color getPlanColor() {
    switch (title) {
      case "Basic":
        return Colors.blue.shade500;
      case "Premium":
        return Colors.purple.shade500;
      case "Enterprise":
        return Colors.orange.shade600;
      default:
        return Colors.grey.shade500;
    }
  }

  // keep this if you want to use it elsewhere; not used directly by the sheet below
  Future<void> saveSubscriptionToService() async {
    await SubscriptionService().createSubscription({
      "userId": userid,
      "planName": title,
      "monthlyFree": price,
      "active": true,
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showSubscriptionDetails(context, title, status, price),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left Section
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: getPlanColor().withOpacity(0.15),
                  radius: 18,
                  child: Icon(Icons.workspace_premium,
                      size: 20, color: getPlanColor()),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 12,
                        color: getPlanColor(),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Right Section (Price)
            Text(
              "\$${price.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSubscriptionDetails(
      BuildContext outerContext, String title, String status, double price) {
    // capture the outer (scaffold) context so we can show SnackBars after closing the sheet
    final scaffoldContext = outerContext;

    showModalBottomSheet(
      context: outerContext,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (bottomSheetContext) {
        String description;
        switch (title) {
          case "Basic":
            description =
                "The Basic plan offers essential features suitable for individuals starting their electric journey.";
            break;
          case "Premium":
            description =
                "The Premium plan provides advanced features and priority support for enthusiasts seeking more control.";
            break;
          case "Enterprise":
            description =
                "The Enterprise plan is designed for businesses requiring comprehensive solutions and dedicated assistance.";
            break;
          default:
            description = "Details about this plan are currently unavailable.";
        }

        // Use StatefulBuilder to manage loading state inside the sheet only
        return StatefulBuilder(
          builder: (context, setState) {
            bool isLoading = false;

            Future<void> handleActivate() async {
              print('Activating $title plan...');
              if (isLoading) return;
              setState(() {
                isLoading = true;
              });

              try {
                // call service and await
                await SubscriptionService().createSubscription({
                  "userId": userid,
                  "planName": title,
                  "monthlyFree": price,
                  "active": true,
                });

                // close the bottom sheet
                Navigator.of(context).pop();

                // show a snackbar on the parent scaffold
                ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                  SnackBar(
                    content: Text("$title plan activated successfully."),
                    duration: const Duration(seconds: 3),
                  ),
                );
                onActivated?.call();
              } catch (e) {
                // keep sheet open and show error
                setState(() {
                  isLoading = false;
                });
                ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                  SnackBar(
                    content: Text("Failed to activate: ${e.toString()}"),
                    duration: const Duration(seconds: 4),
                  ),
                );
              }
            }

            return Padding(
              padding: MediaQuery.of(context).viewInsets.add(
                    const EdgeInsets.all(22),
                  ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Row
                  Row(
                    children: [
                      const Icon(Icons.bolt, color: Colors.teal, size: 28),
                      const SizedBox(width: 10),
                      Text(
                        "$title Plan Details",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Status + Price
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Status: $status",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Price: LKR ${price.toStringAsFixed(2)} / month",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Plan Description
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "You can manage your subscription, view billing history, or update payment methods in the subscription settings.",
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 22),
                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                              isLoading ? null : () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF009DAA),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Close",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isLoading ? null : handleActivate,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF009DAA),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                  ),
                                )
                              : const Text(
                                  "Activate",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
