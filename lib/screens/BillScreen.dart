// screens/BillScreen.dart
import 'package:electric_app/service/subscription_service.dart';
import 'package:electric_app/widget/SubscriptionCard.dart';
import 'package:electric_app/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:electric_app/models/subscription.dart';

class Billscreen extends StatefulWidget {
  const Billscreen({super.key});

  @override
  State<Billscreen> createState() => _BillscreenState();
}

class _BillscreenState extends State<Billscreen> {
  final SubscriptionService _subscriptionService = SubscriptionService();

  final String userId = "fea0a8ac-c615-4d5d-80c3-f5f68782ee4a";

  late Future<Subscription?> _subscriptionsFuture;

  @override
  void initState() {
    super.initState();
    _subscriptionsFuture = _subscriptionService.fetchSubscription(userId);
  }

  Future<void> _refresh() async {
    setState(() {
      _subscriptionsFuture = _subscriptionService.fetchSubscription(userId);
    });
    await _subscriptionsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Subscription?>(
      future: _subscriptionsFuture,
      builder: (BuildContext context, AsyncSnapshot<Subscription?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Always render the plan UI. If snapshot has an error or null data, show plans as "Inactive".
        final bool fetchFailed = snapshot.hasError;
        final Subscription? subscription = snapshot.data;

        return Column(
          children: [
            if (fetchFailed)
              Container(
                width: double.infinity,
                color: Colors.redAccent.withOpacity(0.08),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: const Text(
                  'Could not load your subscription (server error). Showing plans.',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            Expanded(
              child: _buildBillScreen(subscription),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBillScreen(Subscription? subscription) {
    String statusFor(String planTitle) {
      final active = subscription?.planName ?? '';
      print(active);
      return active == planTitle ? "Activated" : "Inactive";
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: Scrollbar(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.receipt_long, size: 30, color: Color(0xFF009daa)),
                  SizedBox(width: 8),
                  Text(
                    "Billing & Subscriptions",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Basic card
              SubscriptionCard(
                title: "Basic",
                status: statusFor("Basic"),
                price: 29.99,
                onActivated: _refresh,
              ),

              // Premium card
              SubscriptionCard(
                title: "Premium",
                status: statusFor("Premium"),
                price: 49.99,
                onActivated: _refresh,
              ),

              // Enterprise card
              SubscriptionCard(
                title: "Enterprise",
                status: statusFor("Enterprise"),
                price: 99.99,
                onActivated: _refresh,
              ),

              const SizedBox(height: 16),

              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.signal_cellular_4_bar),
                          Text(
                            "Linked Smart Cards",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "View 2 linked card(s)",
                        style:
                            TextStyle(fontSize: 20, color: Color(0xFF009daa)),
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        text: "Add New Card",
                        onPressed: () => {},
                        color: const Color(0xFF009daa),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 8,
                shadowColor: Colors.amberAccent.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.amber.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.qr_code, color: Colors.black87, size: 30),
                          Text(
                            "Quick Charge Activation",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Tap or scan to start your charging session instantly.",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.bolt, color: Colors.white),
                          label: const Text(
                            "Activate Charging Session",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber.shade800,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            elevation: 5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
