import 'package:app/modules/candidate/data/models/hive_models/school_model.dart';
import 'package:app/modules/candidate/domain/providers/provider_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class SchoolItem extends StatefulWidget {
  const SchoolItem({super.key, required this.schoolModel});

  final SchoolModel schoolModel;

  @override
  State<SchoolItem> createState() => _SchoolItemState();
}

class _SchoolItemState extends State<SchoolItem> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    var provider = context.watch<ProviderApp>();
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: size.width - 30,
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 70,
            width: size.width - 90,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.schoolModel.major,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  widget.schoolModel.nameSchool,
                  style: const TextStyle(fontSize: 15),
                ),
                Text(
                  '${DateFormat('MM/yyyy').format(widget.schoolModel.to)} - ${DateFormat('MM/yyyy').format(widget.schoolModel.from)}',
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
          IconButton(
              onPressed: () {
                widget.schoolModel.delete();
                provider.fetchAllSchool();
              },
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.red,
              ))
        ],
      ),
    );
  }
}
