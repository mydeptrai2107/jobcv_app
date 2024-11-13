import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class ButtonFilter extends StatelessWidget {
  const ButtonFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.withOpacity(0.3),
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Ionicons.options_outline, color: Colors.black),
          Text(
            'Lọc',
            style: TextStyle(color: Colors.black),
          )
        ],
      ),
    );
  }
}
