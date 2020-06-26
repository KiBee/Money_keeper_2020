import 'dart:io';
import 'package:moneykeeper/Expense.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class ExpenseDB {
  Database _database;

  Future<Database> get database async {
    _database = await initialize();
    return _database;
  }

  ExpenseDB() {}

  initialize() async {
    Directory documentsDir = await getApplicationDocumentsDirectory();
    var path = join(documentsDir.path, "my.db");
    return openDatabase(path, version: 1, onOpen: (dw) {}, onCreate: (dw, version) async {
      await dw.execute("CREATE TABLE Expence (id INTEGER PRIMARY KEY AUTOINCREMENT, price REAL, date TEXT, name TEXT)");
    });
  }

  Future<List<Expense>> getAllExpenses({String value = ""}) async {
    Database dw = await database;

    List<Map> query = await dw.rawQuery("SELECT * FROM Expence$value ORDER BY date DESC");
    var result = List<Expense>();
    query.forEach((r) => result.add(Expense(r["id"], DateTime.parse(r["date"]), r["name"], r["price"])));
    return result;
  }

  // ignore: non_constant_identifier_names
  Future<void> AddExpense(String name, double price, DateTime dateTime) async {
    Database db = await database;
    var dateAsString = dateTime.toString();
    GetTotal();

    await db.rawInsert("INSERT INTO Expence (name,date,price) VALUES (\"$name\", \"$dateAsString\", $price)");
  }

  Future<void> removeExpense(int id) async {
    Database db = await database;
    await db.rawDelete("DELETE FROM Expence WHERE id = $id");
  }

  Future<void> editExpense(int id, String name, double price) async {
    Database dw = await database;
    await dw.rawInsert('''
      UPDATE Expence set name = \"$name\", price = \"$price\" WHERE id = $id
    ''');
  }

  Future<double> GetTotal() async {
    Database db = await database;
    var lst = getAllExpenses();
    double total = 0;
    lst.then((list) {
      list.forEach((element) {
        total += element.price;
      });
    });
    return total;
  }
}
