
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyTextFieldTimePicker extends StatefulWidget {
  final ValueChanged<TimeOfDay> onDateChanged;
  final TimeOfDay initialDate;
  final FocusNode focusNode;
  final String labelText;
  final Icon prefixIcon;
  final Icon suffixIcon;
  final BuildContext ctx;

  MyTextFieldTimePicker({
    Key key,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.focusNode,
    @required this.initialDate,
    @required this.onDateChanged,
	 @required this.ctx
  })  : assert(initialDate != null),
        assert(onDateChanged != null, 'onDateChanged must not be null'),
        super(key: key);

  @override
  _MyTextFieldTimePicker createState() => _MyTextFieldTimePicker();
}

class _MyTextFieldTimePicker extends State<MyTextFieldTimePicker> {
  TextEditingController _controllerDate;
  TimeOfDay _selectedDate;

  @override
	void initState() {

		super.initState();

		_selectedDate = widget.initialDate;

		_controllerDate = TextEditingController();
		_controllerDate.text = _selectedDate.format(widget.ctx);
	}

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: widget.focusNode,
      controller: _controllerDate,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        labelText: widget.labelText,
      ),
      onTap: () => _selectDate(context),
      readOnly: true,
    );
  }

  @override
  void dispose() {
    _controllerDate.dispose();
    super.dispose();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final TimeOfDay pickedDate = await showTimePicker(
      context: context,
		initialTime: widget.initialDate
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      _selectedDate = pickedDate;
      _controllerDate.text = _selectedDate.format(context);
      widget.onDateChanged(_selectedDate);
    }

    if (widget.focusNode != null) {
      widget.focusNode.nextFocus();
    }
  }
}
