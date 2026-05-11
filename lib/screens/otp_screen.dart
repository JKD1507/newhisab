import 'package:flutter/material.dart';
import '../utils/styles.dart';
import 'daily_entry_screen.dart'; // To navigate after success

class OTPScreen extends StatefulWidget {
  final String mobile;
  const OTPScreen({super.key, required this.mobile});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _otpController = TextEditingController();
  
  // Rule: Static OTP for testing (You can later integrate SMS manager)
  final String _correctOTP = "1234"; 

  void _verifyOTP() {
    if (_otpController.text == _correctOTP) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP Verified Successfully!")),
      );
      // Navigate to Daily Entry and clear the login stack
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const DailyEntryScreen()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid OTP. Try again."),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicColors.background,
      appBar: AppBar(
        title: const Text("OTP Verification", style: TextStyle(color: Colors.blueGrey)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.sms_outlined, size: 80, color: Colors.blueGrey),
            const SizedBox(height: 20),
            Text(
              "Code sent to ${widget.mobile}",
              style: const TextStyle(color: Colors.blueGrey, fontSize: 16),
            ),
            const SizedBox(height: 40),
            
            // Neomorphic OTP Input
            Container(
              decoration: neumorphicDecoration(),
              child: TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(letterSpacing: 10, fontSize: 24, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  hintText: "0000",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(15),
                ),
              ),
            ),
            const SizedBox(height: 40),
            
            // Verify Button
            GestureDetector(
              onTap: _verifyOTP,
              child: Container(
                width: double.infinity,
                height: 55,
                decoration: neumorphicDecoration(),
                child: const Center(
                  child: Text("VERIFY OTP", 
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
