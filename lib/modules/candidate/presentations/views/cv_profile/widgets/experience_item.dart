import 'package:app/modules/candidate/data/models/hive_models/experience_model.dart';
import 'package:app/modules/candidate/domain/providers/provider_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class ExperienceItem extends StatefulWidget {
  const ExperienceItem({super.key, required this.experience});
  final ExperienceModel experience;

  @override
  State<ExperienceItem> createState() => _ExperienceItemState();
}

class _ExperienceItemState extends State<ExperienceItem> {
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
                  widget.experience.position,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  widget.experience.nameCompany,
                  style: const TextStyle(fontSize: 15),
                ),
                Text(
                  '${DateFormat('MM/yyyy').format(widget.experience.to)} - ${DateFormat('MM/yyyy').format(widget.experience.from)}',
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
          IconButton(
              onPressed: () {
                widget.experience.delete();
                provider.fetchAllExperience();
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
