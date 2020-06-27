import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moneykeeper/UpdateExpense.dart';
import 'package:moneykeeper/ExpensesModel.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  runApp(MyApp());
}

const months = <DropdownMenuItem<String>>[
  const DropdownMenuItem<String>(value: "", child: const Text("All")),

  const DropdownMenuItem<String>(value: "01-01 02-01", child: const Text("January")),
  const DropdownMenuItem<String>(value: "02-01 03-01", child: const Text("February")),
  const DropdownMenuItem<String>(value: "03-01 04-01", child: const Text("March")),
  const DropdownMenuItem<String>(value: "04-01 05-01", child: const Text("April")),
  const DropdownMenuItem<String>(value: "05-01 06-01", child: const Text("May")),
  const DropdownMenuItem<String>(value: "06-01 07-01", child: const Text("June")),
  const DropdownMenuItem<String>(value: "07-01 08-01", child: const Text("July")),
  const DropdownMenuItem<String>(value: "08-01 09-01", child: const Text("August")),
  const DropdownMenuItem<String>(value: "09-01 10-01", child: const Text("September")),
  const DropdownMenuItem<String>(value: "10-01 11-01", child: const Text("October")),
  const DropdownMenuItem<String>(value: "11-01 12-01", child: const Text("November")),
  const DropdownMenuItem<String>(value: "12-01 01-01", child: const Text("December"))
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
  String selMonth = "";

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
                        var where;



                        if (selMonth == "") {
                          where = "";
                        }
                        else{
                          var vae = value.split(" ");
                           where = " WHERE date >= '"  + DateTime.now().year.toString() + "-" + vae[0] + "' AND date < '"+   (vae[0] == "12-01" ?  (DateTime.now().year+1).toString() +"-"+ vae[1]+ "'" : DateTime.now().year.toString()+ "-"+ vae[1]+ "'") ;
                        }
                        print(where);
                        model.Load(value: where);
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
