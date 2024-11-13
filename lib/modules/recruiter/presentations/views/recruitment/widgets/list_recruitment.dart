import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:app/modules/recruiter/data/provider/recruitment_provider.dart';
import 'item_recruitment.dart';

class ListRecruitment extends StatelessWidget {
  const ListRecruitment({super.key});

  @override
  Widget build(BuildContext context) {
    final list = context
        .watch<RecruitmentProvider>((p) => p.listRecruitment)
        .listRecruitment;
    return ListView.builder(
      itemCount:list.length,
      itemBuilder: (_, index) {
        final item = list[index];
        return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ItemRecruitment(item: item));
      },
    );
  }
}
