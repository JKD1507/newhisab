import 'package:flutter/material.dart';
import '../utils/styles.dart';          // Updated path: up to lib, then utils
import '../db_helper.dart';             // Updated path: up to lib

class EditUserScreen extends StatefulWidget {
  const EditUserScreen({super.key});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _expDateController = TextEditingController();
  String _pmtFlag = 'N';
  bool _userFound = false;

  // Search for user by mobile number
  Future<void> _searchUser() async {
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> results = await db.query(
      'User_Mst',
      where: 'U_Mobile = ?',
      whereArgs: [_searchController.text],
    );

    // Async Gap Fix: check if screen is still active before updating UI
    if (!mounted) return;

    if (results.isNotEmpty) {
      setState(() {
        _userFound = true;
        _nameController.text = results.first['U_Name'];
        _expDateController.text = results.first['U_Exp_Date'];
        _pmtFlag = results.first['Pmt_Flag'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not found!"), backgroundColor: Colors.red),
      );
    }
  }

  // Update user record in SQLite
  Future<void> _updateUser() async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'User_Mst',
      {
        'Pmt_Flag': _pmtFlag,
        'U_Exp_Date': _expDateController.text,
      },
      where: 'U_Mobile = ?',
      whereArgs: [_searchController.text],
    );

    // Async Gap Fix: check if screen is still active before navigating
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("User updated successfully!")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicColors.background,
      appBar: AppBar(
        title: const Text("Admin: Edit User", style: TextStyle(color: Colors.blueGrey)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Neomorphic Search Input
            Container(
              decoration: neumorphicDecoration(),
              child: TextField(
                controller: _searchController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "Enter Mobile to Search",
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(15),
                  suffixIcon: IconButton(
                    onPressed: _searchUser, 
                    icon: const Icon(Icons.search, color: Colors.blueGrey)
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            
            if (_userFound) ...[
              Text("User: ${_nameController.text}", 
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blueGrey)),
              const SizedBox(height: 20),
              
              // Payment Flag Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Paid Status (Y/N):", style: TextStyle(color: Colors.blueGrey)),
                  Switch(
                    activeThumbColor: Colors.green,
                    value: _pmtFlag == 'Y',
                    onChanged: (val) => setState(() => _pmtFlag = val ? 'Y' : 'N'),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Expiry Date Input
              _buildInput("Expiry Date (dd/mm/yyyy)", _expDateController),
              
              const SizedBox(height: 40),
              
              // Update Button
              GestureDetector(
                onTap: _updateUser,
                child: Container(
                  width: double.infinity, 
                  height: 55,
                  decoration: neumorphicDecoration(),
                  child: const Center(
                    child: Text("UPDATE RECORD", 
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          decoration: neumorphicDecoration(),
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: InputBorder.none, 
              contentPadding: EdgeInsets.all(15)
            ),
          ),
        ),
      ],
    );
  }
}
