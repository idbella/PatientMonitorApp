
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget textField({
  String hint = '',
  String label = '',
  String prefix = '',
  Icon icon,
  TextEditingController controller
  })
{
  return Theme(
        data:  ThemeData(
          primaryColor: Color.fromARGB(255, 225, 177, 44),
          primaryColorDark: Colors.red,
        ),
        child:  TextField(
          controller: controller,
          decoration:  InputDecoration(
              border:  OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide:  BorderSide(color: Colors.teal)),
              hintText: hint,
              labelText: label,
              prefixIcon: icon,
              prefixText: ' ',
              suffixStyle: const TextStyle(color: Colors.green)),
        )
    );
}
