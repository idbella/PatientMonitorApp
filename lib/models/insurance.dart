
import 'package:flutter/cupertino.dart';

class Insurance{
	int							id;
	String						title;
	bool							editable;
	TextEditingController	controller = TextEditingController();

	Insurance(this.id,this.title,this.editable);

	static Insurance fromJson(var json)
	{
		Insurance insurance = Insurance(
			json['id'],
			json['title'],
			json['editable'] == 0 ? false:true
		);
		return insurance;
	}
}
