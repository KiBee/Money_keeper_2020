import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moneykeeper/ExpensesModel.dart';

class _UpdateExpensesState extends State<UpdateExpense> {
  int _index;
  double _price;
  String _name;
  ExpensesModel _model;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _UpdateExpensesState(this._model, this._index);

  @override
  Widget build(BuildContext context) {
    if (_index == -1) {
      _name = '';
      _price = 0;
    } else {
      _name = _model.GetNamePrice(_index)[0];
      _price = _model.GetNamePrice(_index)[1];
    }
    return Scaffold(
      appBar: AppBar(title: Text("Add Expense")),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                autovalidate: true,
                initialValue: _price.toString(),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _price = double.parse(value);
                },
              ),
              TextFormField(
                initialValue: _name.toString(),
                onSaved: (value) {
                  _name = value;
                },
              ),
              RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      if (_index != -1)
                        _model.EditExpense(int.parse(_model.GetKey(_index)), _name, _price);
                      else
                        _model.AddExpense(_name, _price);

                      Navigator.pop(context);
                    }
                  },
                  child: Text("Save"))
            ],
          ),
        ),
      ),
    );
  }
}

class UpdateExpense extends StatefulWidget {
  final ExpensesModel _model;
  final int _index;

  UpdateExpense(this._model, this._index);

  @override
  State<StatefulWidget> createState() => _UpdateExpensesState(_model, _index);
}
