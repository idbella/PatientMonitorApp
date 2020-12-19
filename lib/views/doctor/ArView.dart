
import 'dart:typed_data';
import 'package:PatientMonitorMobileApp/globals.dart';
import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/services.dart';

class ARView extends StatefulWidget {
	final String image;

  const ARView({Key key, this.image}) : super(key: key);
  @override
  _ARViewState createState() => _ARViewState();
}

class _ARViewState extends State<ARView> {
Uint8List imageData;
Uint8List rightarrow;
	@override
	void initState() {
		super.initState();
		rootBundle.load(widget.image)
			.then((data){
				print('flu:loaded');
				setState(() => this.imageData = data.buffer.asUint8List());
			}
		).catchError((e){
			Globals.showAlertDialog(context, 'loading error', e.toString(), ()=>Navigator.of(context).pop());
		});
	}
	@override
	Widget build(BuildContext context) {
		if (_controller != null && imageData!=null)
		{
			_controller.addArCoreNode(
				ArCoreNode(
					image: ArCoreImage(
						bytes:imageData,
						width:200,
						height:200
					)
				)
			);
		}
		if (_controller != null && rightarrow!=null)
		{
			_controller.addArCoreNode(
				ArCoreNode(
					image: ArCoreImage(
						bytes:rightarrow,
						width:100,
						height:100
					)
				)
			);
		}
		return Scaffold(
			appBar: AppBar(
				title: Text('ar core'),
			),
			body:ArCoreView(
				onArCoreViewCreated: onCreate,
			)
		);
	}
	ArCoreController _controller;
  void onCreate(ArCoreController controller)
  {

	  print('flu:created');
	  setState(() {
	    _controller = controller;
	  });
  }
}
