import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:party_man/Utils/DatabaseHelper.dart';
import 'package:party_man/models/FunctionM.dart';


class FormRow extends StatefulWidget {
  @override
  String _label;
  String _value;

  FormRow(this._label,this._value);

  State<StatefulWidget> createState() {
    return FormRowDetail(this._label,this._value);
  }
}

class FormRowDetail extends State<FormRow> {

  String _label;
  String _value;

  FormRowDetail(this._label,this._value);

  @override
  Widget build(BuildContext context) {

    TextStyle textStyle_H6 = Theme.of(context).textTheme.headline6;

    return
      Container(
        //color: Colors.white,
        padding: EdgeInsets.all(10.00),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
                flex: 1,
                child:
                Text(this._label, style: textStyle_H6,)),
            Expanded(
                flex: 3,
                child:Text(this._value,style: textStyle_H6,textAlign:TextAlign.left ,maxLines: 2,)),

          ],
        ),
      );
  }
}