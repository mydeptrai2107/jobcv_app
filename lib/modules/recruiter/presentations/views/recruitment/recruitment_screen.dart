import 'package:app/modules/recruiter/data/provider/recruitment_provider.dart';
import 'package:app/modules/recruiter/presentations/views/recruitment/widgets/filter_cv.dart';
import 'package:app/modules/recruiter/presentations/widgets/search_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'widgets/list_recruitment.dart';

class RecruitmentScreen extends StatelessWidget {
  RecruitmentScreen({super.key});
  final TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
      child: Column(
        children: [
          const FilterCv(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: SearchBox(
              hinText: 'Tìm kiếm theo tiêu đề',
              callback: () async {
                await context
                    .read<RecruitmentProvider>()
                    .searchList(textEditingController.text);
              },
              closeSearch: () async {
                textEditingController.clear();
                await context
                    .read<RecruitmentProvider>()
                    .searchList(textEditingController.text);
              },
              textEditingController: textEditingController,
            ),
          ),
          const Expanded(child: ListRecruitment())
        ],
      ),
    );
  }
}
