import 'package:moneykeeper/ExpenseDB.dart';
import 'package:moneykeeper/Expense.dart';
import 'package:scoped_model/scoped_model.dart';
import 'Expense.dart';

class ExpensesModel extends Model {
  List<Expense> _items = [];
  ExpenseDB _database;

  int get recordsCount => _items.length;

  double total = 0;

  ExpensesModel() {
    _database = ExpenseDB();
    Load();
  }

  void Load({value = ''}) {
    total = 0;
    Future<List<Expense>> future = _database.getAllExpenses(value: value);
    future.then((list) {
      _items = list;
      list.forEach((element) {
        total += element.price;
      });
      notifyListeners();
    });
  }

  void SetMonthLoad({value = ''}) {
    total = 0;
    Future<List<Expense>> future = _database.getAllExpenses();
    future.then((list) {
      _items = list;
      list.forEach((element) {
        total += element.price;
      });
      notifyListeners();
    });
  }

//  List<Expence> GetAllExpences() {}

  String GetKey(int index) {
    return _items[index].id.toString();
  }

  String GetText(int index) {
    var z = _items[index];

    return z.name +
        " for " +
        z.price.toString() +
        "\n" +
        z.date.year.toString() +
        '-' +
        (z.date.month < 10 ? '0' + z.date.month.toString() : z.date.month.toString()) +
        '-' +
        (z.date.day < 10 ? '0' + z.date.day.toString() : z.date.day.toString()) +
        ' ' +
        (z.date.hour < 10 ? '0' + z.date.hour.toString() : z.date.hour.toString()) +
        ':' +
        (z.date.minute < 10 ? '0' + z.date.minute.toString() : z.date.minute.toString());
  }

  List<Object> GetNamePrice(int index) {
    return [_items[index].name, _items[index].price];
  }

  Future<void> EditExpense(int id, String name, double price) {
    Future<void> future = _database.editExpense(id, name, price);
    future.then((_) {
      Load();
    });
  }

  void AddExpense(String name, double price) {
    DateTime now = new DateTime.now();

    Future<void> future = _database.AddExpense(name, price, now);
    future.then((_) {
      Load();
    });
    notifyListeners();
  }

  double GetTotalToPrint() {
    var future = _database.GetTotal();
    var s;

    future.then((_) {
      s = _;
    });
    return s;
  }

  String GetMonth(String month) {
    return month;
  }

  void RemoveAt(int index, int id) {
    Future<void> future = _database.removeExpense(id);
    future.then((_) {
      _items.removeAt(index);
      notifyListeners();
    });
  }
}
