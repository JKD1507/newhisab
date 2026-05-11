import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/styles.dart'; 
import '../db_helper.dart';

class DailyEntryScreen extends StatefulWidget {
  const DailyEntryScreen({super.key});

  @override
  State<DailyEntryScreen> createState() => _DailyEntryScreenState();
}

class _DailyEntryScreenState extends State<DailyEntryScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  Future<void> _saveEntry() async {
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter an amount"), backgroundColor: Colors.red),
      );
      return;
    }

    final db = await DatabaseHelper.instance.database;
    String today = DateFormat('dd/MM/yyyy').format(DateTime.now());

    await db.insert('Daily_Mst', {
      'Entry_Date': today,
      'Amount': double.parse(_amountController.text),
      'Remarks': _remarksController.text,
    });

    _amountController.clear();
    _remarksController.clear();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Entry Saved Successfully!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicColors.background,
      appBar: AppBar(
        title: const Text("Daily Entry", style: TextStyle(color: Colors.blueGrey)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            _buildInput("Amount", _amountController, TextInputType.number),
            const SizedBox(height: 25),
            _buildInput("Remarks", _remarksController, TextInputType.text, maxLines: 3),
            const SizedBox(height: 40),
            
            GestureDetector(
              onTap: _saveEntry,
              child: Container(
                width: double.infinity,
                height: 60,
                decoration: neumorphicDecoration(),
                child: const Center(
                  child: Text("SAVE ENTRY", 
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey, fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller, TextInputType type, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5, bottom: 8),
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
        ),
        Container(
          decoration: neumorphicDecoration(),
          child: TextField(
            controller: controller,
            keyboardType: type,
            maxLines: maxLines,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(15),
            ),
          ),
        ),
      ],
    );
  }
}
