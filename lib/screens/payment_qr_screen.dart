import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/styles.dart';          // Updated path
import '../db_helper.dart';             // Updated path

class PaymentQRScreen extends StatelessWidget {
  final String mobile;
  const PaymentQRScreen({super.key, required this.mobile});

  // Logic to simulate payment and update the User_Mst table
  Future<void> _processPayment(BuildContext context) async {
    final db = await DatabaseHelper.instance.database;
    
    // Rule: Extend expiry by 3 months from today
    DateTime now = DateTime.now();
    DateTime newExp = DateTime(now.year, now.month + 3, now.day);
    String formattedExp = DateFormat('dd/MM/yyyy').format(newExp);

    await db.update(
      'User_Mst',
      {'Pmt_Flag': 'Y', 'U_Exp_Date': formattedExp},
      where: 'U_Mobile = ?',
      whereArgs: [mobile],
    );

    // Async Gap Fix: check if screen is still active before navigating
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Payment Successful! Account active for 3 months."),
        backgroundColor: Colors.green,
      ),
    );
    
    // Return to login screen to re-verify
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicColors.background,
      appBar: AppBar(
        title: const Text("Scan & Pay ₹50", style: TextStyle(color: Colors.blueGrey)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Scan to Activate Account",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
              ),
              const SizedBox(height: 30),
              
              // Neomorphic Container for the QR Code
              Container(
                padding: const EdgeInsets.all(20),
                decoration: neumorphicDecoration(),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/jkqr.jpg', 
                    width: 250, 
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              
              const SizedBox(height: 50),
              
              // Payment Confirmation Button
              GestureDetector(
                onTap: () => _processPayment(context),
                child: Container(
                  width: 250,
                  height: 60,
                  decoration: neumorphicDecoration(),
                  child: const Center(
                    child: Text(
                      "CONFIRM PAYMENT",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Tap after successful payment",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
