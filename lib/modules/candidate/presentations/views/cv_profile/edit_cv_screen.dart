import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class EditCVScreen extends StatefulWidget {
  const EditCVScreen({super.key});

  @override
  State<EditCVScreen> createState() => _EditCVScreenState();
}

class _EditCVScreenState extends State<EditCVScreen> {
  WidgetsToImageController controller = WidgetsToImageController();
  Uint8List? bytes;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF'),
      ),
      body: WidgetsToImage(
        controller: controller,
        child: Container(
          height: 200,
          width: 200,
          color: Colors.amber,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.image_outlined),
        onPressed: () async {
          final bytes = await controller.capture();
          this.bytes = bytes;
        },
      ),
    );
  }
}
