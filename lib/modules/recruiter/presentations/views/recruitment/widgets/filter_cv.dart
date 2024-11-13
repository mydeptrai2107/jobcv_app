import 'package:app/modules/candidate/presentations/themes/color.dart';
import 'package:app/modules/recruiter/data/provider/recruitment_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

enum Tag { all, show, hidden }

class FilterCv extends StatefulWidget {
  const FilterCv({super.key});

  @override
  State<FilterCv> createState() => _FilterCvState();
}

class _FilterCvState extends State<FilterCv> {
  final list = [
    {'title': 'Tất cả', 'tag': Tag.all},
    {'title': 'Đang hiển thị', 'tag': Tag.show},
    {'title': 'Tin bị khóa', 'tag': Tag.hidden},
  ];
  int? _selectItem = 0;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(list.length, (index) {
        final item = list[index];
        final isSelect = _selectItem == index;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(item['title'].toString()),
            selectedColor: primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            labelStyle:
                TextStyle(color: isSelect ? Colors.white : Colors.black),
            surfaceTintColor: Colors.white,
            selected: isSelect,
            onSelected: (value) => setState(() {
              _selectItem = value ? index : null;
              context
                  .read<RecruitmentProvider>()
                  .showListByStatus(item['tag'] as Tag);
            }),
          ),
        );
      }),
    );
  }
}
