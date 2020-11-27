import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class button extends StatelessWidget {
  final data;
  final Function presentDate;
  button(this.data, this.presentDate);
  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            child: Text(
              data,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
            onPressed: presentDate,
          )
        : FlatButton(
            textColor: Theme.of(context).primaryColor,
            child: Text(
              'choose date',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: presentDate,
          );
  }
}
