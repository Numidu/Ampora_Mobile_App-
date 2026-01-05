import 'package:electric_app/models/colorThem.dart';
import 'package:electric_app/service/subscription_service.dart';
import 'package:flutter/material.dart';
import 'package:payhere_mobilesdk_flutter/payhere_mobilesdk_flutter.dart';

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
        return const Color(0xFF2ECC71);
      case "Premium":
        return const Color(0xFF3498DB);
      case "Enterprise":
        return const Color(0xFF9B59B6);
      default:
        return Colors.grey;
    }
  }

  IconData getPlanIcon() {
    switch (title) {
      case "Basic":
        return Icons.shield_outlined;
      case "Premium":
        return Icons.star_rounded;
      case "Enterprise":
        return Icons.diamond_rounded;
      default:
        return Icons.subscriptions;
    }
  }

// Payment function eka
  void startPayHerePayment(VoidCallback onSuccess) {
    Map paymentObject = {
      "sandbox": true,
      "merchant_id": "1228683",
      "merchant_secret":
          "Mzg0MjQ0NzY5ODQwODcxMjY4OTA0MjgzMjE3ODE4MzUzNTY2MjU1Mw==",
      "notify_url": "http://sample.com/notify",
      "order_id": "ItemNo12345",
      "items": "$title Plan",
      "amount": price.toStringAsFixed(2),
      "currency": "LKR",
      "first_name": "Saman",
      "last_name": "Perera",
      "email": "samanp@gmail.com",
      "phone": "0771234567",
      "address": "No.1, Galle Road",
      "city": "Colombo",
      "country": "Sri Lanka",
      "delivery_address": "No. 46, Galle road, Kalutara South",
      "delivery_city": "Kalutara",
      "delivery_country": "Sri Lanka",
      "custom_1": "",
      "custom_2": ""
    };

    PayHere.startPayment(paymentObject, (paymentId) {
      onSuccess();
      print("One Time Payment Success. Payment Id: $paymentId");
    }, (error) {
      // Payment Failed nam methanata enawa
      print("One Time Payment Failed. Error: $error");
    }, () {
      // User payment popup eka close kaloth
      print("One Time Payment Dismissed");
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isActive = status == "Activated";
    final planColor = getPlanColor();
    final bool dark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => _showSubscriptionDetails(context, title, status, price),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: dark && !isActive ? const Color(0xFF1A1F2E) : null,
          gradient: isActive
              ? LinearGradient(
                  colors: [
                    planColor.withOpacity(0.95),
                    planColor.withOpacity(0.75),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: dark
                  ? Colors.black.withOpacity(0.6)
                  : (isActive
                      ? planColor.withOpacity(0.35)
                      : Colors.black.withOpacity(0.08)),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            // 🔰 Icon
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? Colors.white.withOpacity(0.2)
                    : planColor.withOpacity(dark ? 0.25 : 0.15),
              ),
              child: Icon(
                getPlanIcon(),
                size: 30,
                color:
                    isActive ? Colors.white : (dark ? Colors.white : planColor),
              ),
            ),

            const SizedBox(width: 14),

            // 📦 Plan info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isActive
                          ? Colors.white
                          : (dark ? Colors.white : Colors.black),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "\$${price.toStringAsFixed(2)} / month",
                    style: TextStyle(
                      fontSize: 14,
                      color: isActive
                          ? Colors.white70
                          : (dark
                              ? Colors.grey.shade400
                              : Colors.grey.shade700),
                    ),
                  ),
                ],
              ),
            ),

            // ✅ Status badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? Colors.white : planColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                isActive ? "ACTIVE" : "VIEW",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isActive ? planColor : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔽 EVERYTHING BELOW = YOUR ORIGINAL LOGIC (UNCHANGED)

  void _showSubscriptionDetails(
      BuildContext outerContext, String title, String status, double price) {
    final scaffoldContext = outerContext;

    showModalBottomSheet(
      context: outerContext,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: AppTheme.background(outerContext),
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

        return StatefulBuilder(
          builder: (context, setState) {
            bool isLoading = false;

            Future<void> handleActivate() async {
              if (isLoading) return;
              setState(() => isLoading = true);

              try {
                await SubscriptionService().createSubscription({
                  "userId": userid,
                  "planName": title,
                  "monthlyFree": price,
                  "active": true,
                });

                Navigator.of(context).pop();

                ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                  SnackBar(
                    content: Text("$title plan activated successfully."),
                  ),
                );
                onActivated?.call();
              } catch (e) {
                setState(() => isLoading = false);
                ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                  SnackBar(content: Text("Failed to activate: $e")),
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
                  Text(
                    "$title Plan",
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(description),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () => startPayHerePayment(handleActivate),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF009DAA),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            "Activate",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
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
