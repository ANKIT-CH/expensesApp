import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './button.dart';

class NewTransactions extends StatefulWidget {
  // String titleInput;
  // String costInput;
  final Function _tempAddTransaction;
  NewTransactions(this._tempAddTransaction);

  @override
  _NewTransactionsState createState() => _NewTransactionsState();
}

class _NewTransactionsState extends State<NewTransactions> {
  final _titleController = TextEditingController();
  final _costController = TextEditingController();
  DateTime _date;

  void _submit() {
    if (_costController.text.isEmpty) return;

    final titleText = _titleController.text;
    final costText = double.parse(_costController.text);

    if (titleText.isEmpty || costText <= 0 || _date == null) return;

    widget._tempAddTransaction(titleText, costText, _date);

    Navigator.of(context).pop();
  }

  void _presentDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018, 1, 1),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) return;
      setState(() {
        _date = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
            top: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: _titleController,
                onSubmitted: (_) => _submit(),
                // onChanged: (val) => {titleInput = val},
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Cost'),
                controller: _costController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submit(),
                // onChanged: (val) => {costInput = val},
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      _date == null
                          ? 'no date picked yet'
                          : 'picked date:${DateFormat.yMd().format(_date)}',
                    ),
                  ),
                  button('choose date', _presentDate),
                ],
              ),
              RaisedButton(
                child: Text('add Transaction'),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
