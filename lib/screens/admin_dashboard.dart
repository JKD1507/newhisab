import 'package:flutter/material.dart';
import 'database_explorer.dart';     // Same folder (screens)
import 'edit_user_screen.dart';      // Same folder (screens)
import '../utils/styles.dart';
import '../backup_service.dart';
import 'login_screen.dart'; // REMOVED 'screens/' and '../'


class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  void _logout(BuildContext context) {
    // Clears the navigation stack and returns to Login
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicColors.background,
      appBar: AppBar(
        title: const Text("ADMIN PANEL", 
          style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold)
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            tooltip: 'Logout',
            onPressed: () => _logout(context),
          )
        ],
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(25),
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        children: [
          // Row 1
          _buildAdminCard(context, "DB Explorer", Icons.manage_search, 
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DatabaseExplorer()))),
          _buildAdminCard(context, "Edit User", Icons.person_search, 
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EditUserScreen()))),
          
          // Row 2
          _buildAdminCard(context, "Backup DB", Icons.backup, 
            () => BackupService.createBackup(context)),
          _buildAdminCard(context, "Restore DB", Icons.settings_backup_restore, 
            () => BackupService.restoreBackup(context)),
        ],
      ),
    );
  }

  Widget _buildAdminCard(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: neumorphicDecoration(), // Uses decoration from styles.dart
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 42, color: Colors.blueGrey),
            const SizedBox(height: 12),
            Text(title, 
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold, 
                color: Colors.blueGrey,
                fontSize: 14
              ),
            ),
          ],
        ),
      ),
    );
  }
}
