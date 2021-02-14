import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


class DropDowns{
  Widget dropDownAndroid(List data,String selectedValue,Function onChanged){
    return DropdownButton(
      isExpanded: true,
      value: selectedValue,
      onChanged: (newValue) {
        onChanged(newValue);
        print(newValue);
      },
      items: [
        for (String i in data)
          DropdownMenuItem(
            value: i,
            child: Center(
              child: Text('$i'),
            ),
          )
      ],
    );
  }

  Future<Widget> showPicker(context,List data,Function onChanged) {
    String selectedValue=data.first;
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return CupertinoPicker(
            backgroundColor: Colors.white,
            onSelectedItemChanged: (value) {
              print(value);
              onChanged(data[value]);
            },
            itemExtent: 32.0,
            children: [
              for (String i in data)
                DropdownMenuItem(
                  value: i,
                  child: Center(child: Text('$i')),
                )
            ],
          );
        });
  }
}