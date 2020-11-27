import 'dart:ui';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import './models/transaction.dart';
import './widgets/transactions_list.dart';
import './widgets/new_transactions.dart';
import './widgets/chart.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fApp',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        accentColor: Colors.lightGreenAccent,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                button: TextStyle(color: Colors.white),
              ),
        ),
      ),
      home: MyPage(),
    );
  }
}

class MyPage extends StatefulWidget {
  //properties
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final List<Transaction> _transactions = [
    // Transaction(
    //   id: 't1',
    //   title: 'shoes',
    //   cost: 88.90,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'bag',
    //   cost: 40.65,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't3',
    //   title: 'bag',
    //   cost: 4.6,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't4',
    //   title: 'bag',
    //   cost: 40.65,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't5',
    //   title: 'bag',
    //   cost: 40.65,
    //   date: DateTime.now(),
    // ),
    Transaction(
      id: 't6',
      title: 'bag',
      cost: 40.65,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't7',
      title: 'bag',
      cost: 40.65,
      date: DateTime.now(),
    ),
  ];

  bool _switch = false;

  List<Transaction> get _recent {
    return _transactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransactions(
      String tempTitle, double tempCost, DateTime chosenDate) {
    final newtransact = Transaction(
      id: DateTime.now().toString(),
      title: tempTitle,
      cost: tempCost,
      date: chosenDate,
    );
    setState(() {
      _transactions.add(newtransact);
    });
  }

  void _newTransactionInitiation(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransactions(_addNewTransactions),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteTx(String id) {
    setState(() {
      _transactions.removeWhere((element) => element.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mQ = MediaQuery.of(context);

    final PreferredSizeWidget appbar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(
              'Expenses',
              style: TextStyle(fontFamily: 'OpenSans'),
            ),
            trailing: Row(children: <Widget>[
              GestureDetector(
                child: Icon(CupertinoIcons.add),
                onTap: () => _newTransactionInitiation(context),
              ),
            ]),
          )
        : AppBar(
            title: Text(
              'Expenses',
              style: TextStyle(fontFamily: 'OpenSans'),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _newTransactionInitiation(context),
              )
            ],
          );

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (mQ.orientation == Orientation.landscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('show chart'),
                  Switch.adaptive(
                      value: _switch,
                      onChanged: (value) {
                        setState(() {
                          _switch = value;
                        });
                      })
                ],
              ),
            if (mQ.orientation == Orientation.landscape)
              _switch
                  ? Container(
                      height: (mQ.size.height -
                              appbar.preferredSize.height -
                              mQ.padding.top) *
                          0.7,
                      child: Chart(_recent))
                  : Container(
                      height: (mQ.size.height -
                              appbar.preferredSize.height -
                              mQ.padding.top) *
                          0.7,
                      child: TransactionsList(_transactions, _deleteTx)),
            if (mQ.orientation != Orientation.landscape)
              Container(
                  height: (mQ.size.height -
                          appbar.preferredSize.height -
                          mQ.padding.top) *
                      0.3,
                  child: Chart(_recent)),
            if (mQ.orientation != Orientation.landscape)
              Container(
                  height: (mQ.size.height -
                          appbar.preferredSize.height -
                          mQ.padding.top) *
                      0.7,
                  child: TransactionsList(_transactions, _deleteTx)),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appbar,
            child: pageBody,
          )
        : Scaffold(
            appBar: appbar,
            body: pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => _newTransactionInitiation(context),
            ),
          );
  }
}
