import 'package:flutter/material.dart';
import '../utils/styles.dart'; // Add '../utils/' because it is in a different folder
import 'admin_dashboard.dart'; // Import the dashboard

class AdminPasswordScreen extends StatefulWidget {
  const AdminPasswordScreen({super.key});

  @override
  State<AdminPasswordScreen> createState() => _AdminPasswordScreenState();
}

class _AdminPasswordScreenState extends State<AdminPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscured = true;

  void _verifyPassword() {
    // Hardcoded password as per your PDF requirement
    if (_passwordController.text == "jkdmjd") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Admin Access Granted")),
      );
      
      // Updated: Navigate to Admin Dashboard and remove current screen from stack
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminDashboard()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Incorrect Password!"),
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blueGrey),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Admin Security", style: TextStyle(color: Colors.blueGrey)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_person, size: 80, color: Colors.blueGrey),
              const SizedBox(height: 30),
              const Text(
                "Enter Admin Password",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.blueGrey),
              ),
              const SizedBox(height: 30),
              
              // Neomorphic Password Input
              Container(
                decoration: neumorphicDecoration(),
                child: TextField(
                  controller: _passwordController,
                  obscureText: _isObscured,
                  decoration: InputDecoration(
                    hintText: "Password",
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    suffixIcon: IconButton(
                      icon: Icon(_isObscured ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _isObscured = !_isObscured),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Neomorphic Login Button
              GestureDetector(
                onTap: _verifyPassword,
                child: Container(
                  width: double.infinity,
                  height: 55,
                  decoration: neumorphicDecoration(),
                  child: const Center(
                    child: Text(
                      "VERIFY & ENTER",
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        color: Colors.blueGrey,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
