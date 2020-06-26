import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moneykeeper/UpdateExpense.dart';
import 'package:moneykeeper/ExpensesModel.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  runApp(MyApp());
}

const months = <DropdownMenuItem<String>>[
  const DropdownMenuItem<String>(value: "date >= '2019-01-01'", child: const Text("All")),
  const DropdownMenuItem<String>(value: "date >= '2020-01-01' AND date < '2020-02-01'", child: const Text("January")),
  const DropdownMenuItem<String>(value: "date >= '2020-02-01' AND date < '2020-03-01'", child: const Text("February")),
  const DropdownMenuItem<String>(value: "date >= '2020-03-01' AND date < '2020-04-01'", child: const Text("March")),
  const DropdownMenuItem<String>(value: "date >= '2020-04-01' AND date < '2020-05-01'", child: const Text("April")),
  const DropdownMenuItem<String>(value: "date >= '2020-05-01' AND date < '2020-06-01'", child: const Text("May")),
  const DropdownMenuItem<String>(value: "date >= '2020-06-01' AND date < '2020-07-01'", child: const Text("June")),
  const DropdownMenuItem<String>(value: "date >= '2020-07-01' AND date < '2020-08-01'", child: const Text("July")),
  const DropdownMenuItem<String>(value: "date >= '2020-08-01' AND date < '2020-09-01'", child: const Text("August")),
  const DropdownMenuItem<String>(value: "date >= '2020-09-01' AND date < '2020-10-01'", child: const Text("September")),
  const DropdownMenuItem<String>(value: "date >= '2020-10-01' AND date < '2020-11-01'", child: const Text("October")),
  const DropdownMenuItem<String>(value: "date >= '2020-11-01' AND date < '2020-12-01'", child: const Text("November")),
  const DropdownMenuItem<String>(value: "date >= '2020-12-01' AND date < '2021-01-01'", child: const Text("December"))
];

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Keeper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePage createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  String selMonth = "All";

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ExpensesModel>(
      model: ExpensesModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Money Keeper 2020"),
        ),
        body: ScopedModelDescendant<ExpensesModel>(
          builder: (context, child, model) => ListView.separated(
              itemBuilder: (context, index) {
                if (index == 0) {
                  var totalPrint = model.total;
                  return ListTile(
                    title: Text("Total expences $totalPrint"),
                    trailing: new DropdownButton(
                      value: model.GetMonth(selMonth),
                      items: months,
                      onChanged: (String value) {
                        selMonth = value;
                        model.Load(value: " WHERE " + value);
                      },

//
                    ),
                  );
                } else {
                  index -= 1;
                  return Dismissible(
                    key: Key(model.GetKey(index)),
                    confirmDismiss: (DismissDirection direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext dismissContext) {
                          return AlertDialog(
                            title: const Text("Confirm"),
                            content: const Text("Are you sure you wish to delete this item?"),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () => Navigator.of(dismissContext).pop(false),
                                child: const Text("CANCEL"),
                              ),
                              FlatButton(
                                  onPressed: () {
                                    model.RemoveAt(index, int.parse(model.GetKey(index)));
                                    Navigator.of(dismissContext).pop();
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text("Deleted record $index"),
                                    ));
                                    model.Load();
                                  },
                                  child: const Text("DELETE")),
                            ],
                          );
                        },
                      );
                    },
                    child: ListTile(
                      title: Text(model.GetText(index)),
                      leading: Icon(Icons.attach_money),
                      trailing: Icon(Icons.delete),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return UpdateExpense(model, index);
                        }));
                      },
                    ),
                  );
                }
              },
              separatorBuilder: (context, index) => Divider(),
              itemCount: model.recordsCount + 1),
        ),
        floatingActionButton: ScopedModelDescendant<ExpensesModel>(
          builder: (context, child, model) => FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return UpdateExpense(model, -1);
              }));
            },
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
