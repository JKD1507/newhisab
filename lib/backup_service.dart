import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class BackupService {
  static Future<void> createBackup(BuildContext context) async {
    try {
      String dbPath = await getDatabasesPath();
      File dbFile = File(join(dbPath, 'hisab.db'));
      
      final directory = await getExternalStorageDirectory();
      String backupPath = join(directory!.path, 'hisab_backup.db');
      
      await dbFile.copy(backupPath);
      await Share.shareXFiles([XFile(backupPath)], text: 'My Hisab DB Backup');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Backup Failed: $e")));
    }
  }

  static Future<void> restoreBackup(BuildContext context) async {
    // Note: Restoration usually requires picking a file via file_picker
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Select backup file to restore...")));
  }
}
