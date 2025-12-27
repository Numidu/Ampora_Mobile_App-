// screens/BillScreen.dart
import 'package:electric_app/provider/authj_provider.dart';
import 'package:electric_app/service/subscription_service.dart';
import 'package:electric_app/widget/Logo_lorder.dart';
import 'package:electric_app/widget/SubscriptionCard.dart';
import 'package:flutter/material.dart';
import 'package:electric_app/models/subscription.dart';
import 'package:provider/provider.dart%20';

class Billscreen extends StatefulWidget {
  const Billscreen({super.key});

  @override
  State<Billscreen> createState() => _BillscreenState();
}

class _BillscreenState extends State<Billscreen> {
  final SubscriptionService _subscriptionService = SubscriptionService();

  String? userId;

  late Future<Subscription?> _subscriptionsFuture;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) return;
    _initialized = true;

    final user = context.read<AuthProvider>().currentUser;
    userId = user?.userId;

    if (userId != null) {
      _subscriptionsFuture = _subscriptionService.fetchSubscription(userId!);
    } else {
      _subscriptionsFuture = Future.error("User not logged in");
    }
  }

  Future<void> _refresh() async {
    if (userId == null) return;

    setState(() {
      _subscriptionsFuture = _subscriptionService.fetchSubscription(userId!);
    });

    await _subscriptionsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Subscription?>(
      future: _subscriptionsFuture,
      builder: (BuildContext context, AsyncSnapshot<Subscription?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: LogoLoader(
            size: 70,
          ));
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
      return active == planTitle ? "Activated" : "Inactive";
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: Scrollbar(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const Row(
                  children: [
                    Icon(Icons.receipt_long,
                        size: 30, color: Color(0xFF009daa)),
                    SizedBox(width: 8),
                    Text(
                      "Billing & Subscriptions",
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Subscription Plans
                SubscriptionCard(
                  title: "Basic",
                  status: statusFor("Basic"),
                  price: 29.99,
                  onActivated: _refresh,
                  userid: userId!,
                ),
                SubscriptionCard(
                  title: "Premium",
                  status: statusFor("Premium"),
                  price: 49.99,
                  onActivated: _refresh,
                  userid: userId!,
                ),
                SubscriptionCard(
                  title: "Enterprise",
                  status: statusFor("Enterprise"),
                  price: 99.99,
                  onActivated: _refresh,
                  userid: userId!,
                ),

                const SizedBox(height: 24),

                // 🔹 Plan Benefits
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Plan Benefits",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        _benefitRow("Free monthly charging sessions"),
                        _benefitRow("Priority customer support"),
                        _benefitRow("Faster charging access"),
                        _benefitRow("Discounted extra usage"),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 🔹 Billing Summary
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Billing Summary",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        _summaryRow(
                            "Current Plan", subscription?.planName ?? "None"),
                        _summaryRow(
                            "Monthly Fee",
                            subscription != null
                                ? "\$${subscription.monthlyFeee}"
                                : "-"),
                        _summaryRow(
                            "Payment Status",
                            subscription?.active == true
                                ? "Active"
                                : "Inactive"),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _benefitRow(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 20),
          SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _summaryRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
