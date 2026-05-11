import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';

class BackupService {
  // Logic to share a copy of the database as a backup
  static Future<void> createBackup(BuildContext context) async {
    try {
      String databasesPath = await getDatabasesPath();
      String dbPath = join(databasesPath, 'hisab.db');
      File dbFile = File(dbPath);

      if (await dbFile.exists()) {
        // --- THIS LINE FIXES THE "ASYNC GAP" ERROR ---
        if (!context.mounted) return;

        await Share.shareXFiles([XFile(dbPath)], text: 'My Hisab DB Backup');
      } else {
        // --- ADDED GUARD HERE TOO ---
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error: Database file not found!")),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Backup failed: $e")),
      );
    }
  }

  // Logic to restore by picking a .db file and overwriting the current one
  static Future<void> restoreBackup(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );

      if (result != null && result.files.single.path != null) {
        File backupFile = File(result.files.single.path!);
        
        String databasesPath = await getDatabasesPath();
        String dbPath = join(databasesPath, 'hisab.db');

        await backupFile.copy(dbPath);

        // --- ADDED GUARD HERE TOO ---
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Database restored! Please restart the app."),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Restore failed: $e"), backgroundColor: Colors.red),
      );
    }
  }
}
