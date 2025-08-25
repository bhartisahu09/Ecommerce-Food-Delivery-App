import 'package:flutter/material.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  String _selectedMethod = "Cash";

  final List<Map<String, dynamic>> paymentMethods = [
    {"title": "Cash", "icon": "assets/images/cash.png"},
    {"title": "PayPal", "icon": "assets/images/paypal.png"},
    {"title": "Google Pay", "icon": "assets/images/gpay.png"},
    {"title": "Phone Pay", "icon": "assets/images/phonepay.png"},
    {"title": "**** **** **** 2259", "icon": "assets/images/mastercard.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Payment Methods",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: paymentMethods.length + 1,
              itemBuilder: (context, index) {
                if (index < paymentMethods.length) {
                  final method = paymentMethods[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _selectedMethod == method["title"]
                            ? Colors.deepOrange
                            : Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    child: ListTile(
                      leading: Image.asset(
                        method["icon"],
                        height: 32,
                        width: 32,
                      ),
                      title: Text(
                        method["title"],
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      trailing: Radio<String>(
                        value: method["title"],
                        groupValue: _selectedMethod,
                        activeColor: Colors.deepOrange,
                        onChanged: (value) {
                          setState(() {
                            _selectedMethod = value!;
                          });
                        },
                      ),
                    ),
                  );
                } else {
                  // Add New Card option
                  return GestureDetector(
                    onTap: () {
                      // TODO: Navigate to add card screen
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.add, color: Colors.red),
                          SizedBox(width: 10),
                          Text(
                            "Add New Card",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),

          // Apply Button
          Container(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                Navigator.pop(context, _selectedMethod);
              },
              child: const Text(
                "Apply",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
