import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('hisab.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // 1. Create User Master Table
    await db.execute('''
      CREATE TABLE User_Mst (
        U_Name TEXT NOT NULL,
        U_Mobile TEXT NOT NULL,
        U_City TEXT NOT NULL,
        U_Email TEXT NOT NULL,
        U_Reg_Date TEXT NOT NULL,
        U_Month INTEGER NOT NULL,
        U_Exp_Date TEXT NOT NULL,
        Pmt_Flag TEXT NOT NULL
      )
    ''');

    // 2. Create Daily Entry Table
    await db.execute('''
      CREATE TABLE Daily_Mst (
        Entry_ID INTEGER PRIMARY KEY AUTOINCREMENT,
        Entry_Date TEXT NOT NULL,
        Amount REAL NOT NULL,
        Remarks TEXT
      )
    ''');

    // 3. Insert Default Test User
    String systemDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    await db.insert('User_Mst', {
      'U_Name': 'Test User',
      'U_Mobile': '1234567890',
      'U_City': 'Ahmedabad',
      'U_Email': 'jaymin1965@gmail.com',
      'U_Reg_Date': systemDate,
      'U_Month': 1,
      'U_Exp_Date': '15/07/1995',
      'Pmt_Flag': 'N'
    });
  }
}
