import 'package:flutter/material.dart';
import '../utils/styles.dart'; // Change 'styles.dart' to this
import '../db_helper.dart';    // Change 'db_helper.dart' to this

class DatabaseExplorer extends StatefulWidget {
  const DatabaseExplorer({super.key});

  @override
  State<DatabaseExplorer> createState() => _DatabaseExplorerState();
}

class _DatabaseExplorerState extends State<DatabaseExplorer> {
  String _selectedTable = 'User_Mst';
  List<Map<String, dynamic>> _records = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  // Fetches latest records from selected table
  Future<void> _refreshData() async {
    setState(() => _isLoading = true);
    final db = await DatabaseHelper.instance.database;
    final List<Map<String, dynamic>> data = await db.query(_selectedTable);
    setState(() {
      _records = data;
      _isLoading = false;
    });
  }

  // Deletes a specific record based on the primary identifier
  Future<void> _deleteRecord(Map<String, dynamic> record) async {
    final db = await DatabaseHelper.instance.database;
    String idColumn = _selectedTable == 'User_Mst' ? 'U_Mobile' : 'Entry_ID';
    var idValue = record[idColumn];

    await db.delete(
      _selectedTable,
      where: '$idColumn = ?',
      whereArgs: [idValue],
    );

    _refreshData(); // Reload list after deletion
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Record Deleted")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicColors.background,
      appBar: AppBar(
        title: const Text("DB Explorer", style: TextStyle(color: Colors.blueGrey)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // Table Switcher
          DropdownButton<String>(
            value: _selectedTable,
            items: ['User_Mst', 'Daily_Mst'].map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
            onChanged: (newValue) {
              setState(() => _selectedTable = newValue!);
              _refreshData();
            },
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: _records.length,
            padding: const EdgeInsets.all(20),
            itemBuilder: (context, index) {
              final record = _records[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                decoration: neumorphicDecoration(),
                child: ListTile(
                  title: Text(
                    _selectedTable == 'User_Mst' ? record['U_Name'] : "Entry: ₹${record['Amount']}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    _selectedTable == 'User_Mst' ? record['U_Mobile'] : record['Entry_Date'],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => _showDeleteDialog(record),
                  ),
                ),
              );
            },
          ),
    );
  }

  void _showDeleteDialog(Map<String, dynamic> record) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Record?"),
        content: const Text("This action cannot be undone."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("CANCEL")),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _deleteRecord(record);
            }, 
            child: const Text("DELETE", style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );
  }
}
