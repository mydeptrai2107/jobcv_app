import 'package:app/modules/candidate/data/models/hive_models/skill_model.dart';
import 'package:app/modules/candidate/domain/providers/provider_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SkillItem extends StatefulWidget {
  const SkillItem({super.key, required this.skillModel});

  final SkillModel skillModel;

  @override
  State<SkillItem> createState() => _SkillItemState();
}

class _SkillItemState extends State<SkillItem> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    var provider = context.watch<ProviderApp>();
    return Container(
      margin: const EdgeInsets.only(top: 10),
      width: size.width - 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: size.width - 90,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.skillModel.nameSkill,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  widget.skillModel.description,
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
          IconButton(
              onPressed: () {
                widget.skillModel.delete();
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
