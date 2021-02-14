import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class DatePickers{
  Future<DateTime> selectDateAndroid(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    DateTime picked=DateTime.now();
    picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1990, 8),
        lastDate: DateTime(2101),
        builder: (context,child){
          return Theme(data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.black,
              onPrimary: Colors.white,
              surface: Theme.of(context).primaryColor,
              onSurface: Colors.black,
            ),
          ), child: child);
    }
    );
    return picked;

  }

  Future<DateTime> selectDateIOS(BuildContext context,Function onChanged) async {
    DateTime selectedDate = DateTime.now();
    DateTime picked=DateTime.now();
    final picker = CupertinoDatePicker(
      initialDateTime: selectedDate,
      onDateTimeChanged: (date){
        picked=date;
        onChanged(date);
      },
    );
    showCupertinoModalPopup(context: context, builder: (context){
      return Container(
        height: 250.0,
        child: Column(
          children: [
            Container(
                height: 200.0,
                child: picker
            ),
            CupertinoButton(
              child: Text('OK'),
              onPressed: () {
                print(picked);
                Navigator.pop(context,picked);
              },
            )
          ],
        ),
      );
    });
    return picked;

  }

}

