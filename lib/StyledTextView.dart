
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget textField({
	bool	 obscure = false,
	String hint = '',
	String label = '',
	String prefix = '',
	Icon icon,
	TextEditingController controller,
	Widget suffix,
	bool multiline = false,
	TextInputType inputtype = TextInputType.text,
	int maxlines = 1
	})
{
  return 
    Theme(
      data:  ThemeData(
        primaryColor: Color.fromARGB(255, 225, 177, 44),
        primaryColorDark: Colors.red,
      ),
      child:
      TextField(
			keyboardType: inputtype,
			maxLines: maxlines,
			obscureText: obscure,
      	controller: controller,
      	decoration:  InputDecoration(
            border:  OutlineInputBorder(
            	borderRadius: BorderRadius.all(Radius.circular(20)),
            	borderSide:  BorderSide(color: Colors.teal)),
            hintText: hint,
            labelText: label,
            suffix: suffix,
            prefixIcon: icon,
            prefixText: ' ',
            suffixStyle: const TextStyle(color: Colors.green)),
      )
    );
}