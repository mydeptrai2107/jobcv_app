import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  final String hinText;
  final VoidCallback? callback;
  final VoidCallback? closeSearch;
  final TextEditingController textEditingController;
  const SearchBox(
      {super.key,
      required this.hinText,
      this.callback,
      required this.textEditingController, this.closeSearch});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: SizedBox(
          height: 42,
          child: TextField(
            controller: textEditingController,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                hintText: hinText,
                suffixIcon:
                    IconButton(onPressed: closeSearch, icon: const Icon(Icons.close)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: const BorderSide(width: 0.5))),
          ),
        )),
        const SizedBox(width: 8),
        SizedBox(
          height: 42,
          child: ElevatedButton(
            onPressed: callback,
            style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))),
            child: const Text(
              'Tìm kiếm',
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
