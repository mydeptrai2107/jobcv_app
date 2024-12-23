import 'package:app/modules/candidate/data/repositories/user_repositories.dart';
import 'package:app/modules/candidate/presentations/themes/color.dart';
import 'package:app/shared/provider/provider_apply.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerScreen extends StatefulWidget {
  const PDFViewerScreen(
      {super.key,
      required this.name,
      required this.pathCV,
      this.recruiterSeen = false,
      required this.id});

  final String name;
  final String pathCV;
  final bool recruiterSeen;
  final String id;
  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  UserRepositories userRepositories = UserRepositories();
  final List<bool> _selectedFruits = <bool>[true, false];
  final fruits = const [
    {'title': 'Phê duyệt', 'status': '2'},
    {'title': 'Loại', 'status': '0'},
  ];
  String _status = '2';
  _approve() async {
    await Modular.get<ProviderApply>().updateCv(widget.id, _status);
    Modular.to.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        actions: [
          if (widget.recruiterSeen)
            TextButton(
              onPressed: _approve,
              child: const Text('Xác nhận'),
            )
        ],
      ),
      body: Column(
        children: [
          if (widget.recruiterSeen)
            ToggleButtons(
              direction: Axis.horizontal,
              onPressed: (int index) {
                setState(() {
                  for (int i = 0; i < _selectedFruits.length; i++) {
                    _selectedFruits[i] = i == index;
                  }
                  _status = fruits[index]['status'].toString();
                });
              },
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              selectedColor: Colors.white,
              fillColor: primaryColor,
              color: Colors.blue,
              constraints: const BoxConstraints(
                minHeight: 35.0,
                minWidth: 80.0,
              ),
              isSelected: _selectedFruits,
              children: fruits.map((e) => Text(e['title'].toString())).toList(),
            ),
          Expanded(
            child: Center(
              child: SfPdfViewer.network(
                userRepositories.getAvatar(widget.pathCV),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
