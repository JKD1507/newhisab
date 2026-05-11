import 'package:flutter/material.dart';
import '../utils/styles.dart';
import '../db_helper.dart';
import 'admin_password_screen.dart';
import 'payment_qr_screen.dart';
import 'otp_screen.dart'; // ONLY this one for OTP


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _mobileController = TextEditingController();

  void _handleLogin() async {
    String mobile = _mobileController.text.trim();

    if (mobile.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a mobile number")),
      );
      return;
    }

    // 1. Admin Access Check
    if (mobile == "9879015142") {
      Navigator.push(
        context, 
        MaterialPageRoute(builder: (context) => const AdminPasswordScreen())
      );
      return;
    }

    // 2. User Database Check
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> users = await db.query(
      'User_Mst',
      where: 'U_Mobile = ?',
      whereArgs: [mobile],
    );

    // FIX: Check if screen is still active after 'await'
    if (!mounted) return;

    if (users.isNotEmpty) {
      var user = users.first;
      
      // 3. Payment Status Check ('Pmt_Flag')
      if (user['Pmt_Flag'] == 'N') {
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => PaymentQRScreen(mobile: mobile))
        );
      } else {
        // 4. Send OTP and Verify (Paid users)
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => OTPScreen(mobile: mobile))
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User not found! Please contact admin."),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo/Title Icon
              const Icon(Icons.account_balance_wallet, size: 80, color: Colors.blueGrey),
              const SizedBox(height: 20),
              const Text(
                "MY HISAB", 
                style: TextStyle(
                  fontSize: 32, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.blueGrey,
                  letterSpacing: 1.5
                )
              ),
              const SizedBox(height: 60),
              
              // Neomorphic Mobile Input
              Container(
                decoration: neumorphicDecoration(),
                child: TextField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    hintText: "Enter Mobile Number",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.phone_android, color: Colors.blueGrey),
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              
              // Neomorphic Login Button
              GestureDetector(
                onTap: _handleLogin,
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: neumorphicDecoration(),
                  child: const Center(
                    child: Text(
                      "LOGIN", 
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold, 
                        color: Colors.blueGrey,
                        letterSpacing: 1.2
                      )
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Verify your account via OTP",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
