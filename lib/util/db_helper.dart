import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

abstract class DB {
  static Database _db;

  static List<String> _tableQueries = [
    'CREATE TABLE IF NOT EXISTS customers (id INTEGER PRIMARY KEY AUTOINCREMENT, customerName TEXT, customerPhone TEXT)',
    'CREATE TABLE IF NOT EXISTS items (id INTEGER PRIMARY KEY AUTOINCREMENT, itemName TEXT, itemDescription TEXT, costPrice REAL, charges REAL, unit TEXT, discount FLOAT)',
    'CREATE TABLE IF NOT EXISTS stocks (id INTEGER PRIMARY KEY AUTOINCREMENT, itemId INTEGER NOT NULL, count INTEGER DEFAULT 0 NOT NULL, committed INTEGER DEFAULT 0, FOREIGN KEY (itemId) REFERENCES items (id) ON DELETE CASCADE)',
    'CREATE TABLE IF NOT EXISTS purchase_orders (id INTEGER PRIMARY KEY AUTOINCREMENT, orderNo TEXT NOT NULL, orderedOn TEXT NOT NULL, status INTEGER NOT NULL)',
    'CREATE TABLE IF NOT EXISTS purchase_order_items (id INTEGER PRIMARY KEY AUTOINCREMENT, itemId INTEGER NOT NULL, orderId INTEGER NOT NULL, quantity INTEGER NOT NULL, price FLOAT, FOREIGN KEY (itemId) REFERENCES items (id), FOREIGN KEY (orderId) REFERENCES purchase_orders (id))',
    'CREATE TABLE IF NOT EXISTS sale_orders (id INTEGER PRIMARY KEY AUTOINCREMENT, orderNo TEXT NOT NULL, orderedOn TEXT NOT NULL, status INTEGER NOT NULL, customerId INTEGER NOT NULL, FOREIGN KEY (customerId) REFERENCES customers (id))',
    'CREATE TABLE IF NOT EXISTS sale_order_items (id INTEGER PRIMARY KEY AUTOINCREMENT, itemId INTEGER NOT NULL, orderId INTEGER NOT NULL, quantity INTEGER NOT NULL, price FLOAT, FOREIGN KEY (itemId) REFERENCES items (id), FOREIGN KEY (orderId) REFERENCES sale_orders (id))',
  ];

  static int get _version => 1;

  static Future<void> init() async {
    if (_db != null) {
      return;
    }

    try {
      var databasePath = await getDatabasesPath();
      String _path = join(databasePath, 'biller.db');

      _db = await openDatabase(
        _path,
        version: _version,
        onCreate: _onCreate,
        onConfigure: _onConfigure,
      );
    } catch (ex) {
      print(ex);
    }
  }

  static void _createTable(Database _db) {
    _tableQueries.forEach((query) async {
      await _db.execute(query);
    });
  }

  static void _onConfigure(Database db) {}

  static void _onCreate(Database db, int version) async {
    print('Creating DB...');
    _createTable(db);
  }

  static Future<List<Map<String, dynamic>>> query(String table) async =>
      _db.query(table);

  static Future<int> insert(String table, model) async =>
      await _db.insert(table, model.toMap());

  static Future<int> update(String table, model) async => await _db
      .update(table, model.toMap(), where: 'id = ?', whereArgs: [model.id]);

  static Future<int> delete(String table, model) async =>
      await _db.delete(table, where: 'id = ?', whereArgs: [model.id]);

  static Future<Batch> batch() async => _db.batch();

  // Raw queries

  static Future<List<Map<String, dynamic>>> rawQuery(String query) async =>
      _db.rawQuery(query);

  static Future<int> rawDelete(String query) async => _db.rawDelete(query);
}
