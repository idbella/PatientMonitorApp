
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart';

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
		);
		rootBundle.load('images/arrow.png')
			.then((data){
				print('flu:loaded');
				setState(() => this.rightarrow = data.buffer.asUint8List());
			}
		);
	}
	@override
	Widget build(BuildContext context) {
		if (imageData!=null)
		{
			print('one');
			_controller.addArCoreNode(
				ArCoreNode(
					image: ArCoreImage(
						bytes:imageData,
						width:300,
						height:300
					)
				)
			);
		}
		if (rightarrow!=null)
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
				type: ArCoreViewType.STANDARDVIEW,
				enableUpdateListener: false,
				enablePlaneRenderer: false,
				onArCoreViewCreated: onCreate,
			)
		);
	}
	ArCoreController _controller;
  void onCreate(ArCoreController controller)
  {
	  print('flu:created');
	  _controller = controller;
  }
}