import 'package:app/modules/recruiter/data/provider/recruitment_provider.dart';
import 'package:app/modules/recruiter/presentations/views/home/widgets/recruitment_efficiency.dart';
import 'package:app/modules/recruiter/presentations/views/management/widgets/item_cv_widget.dart';
import 'package:app/modules/recruiter/presentations/views/recruitment/widgets/item_recruitment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../recruitment/add_recruitment.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecruitmentProvider>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RecruitmentEfficiency(list: provider.listRecruitment),
              const SizedBox(height: 16.0),
              const AddRecruitment(),
              // ChartRecruitment()
              const SizedBox(height: 16.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tin tuyển dụng đã tạo gần đây',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  if (provider.recentlyCreatedR != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ItemRecruitment(item: provider.recentlyCreatedR!),
                    )
                ],
              ),
              const SizedBox(height: 26.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CV đã xem gần đây',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  if (provider.applyRecently != null)
                    ItemCV(apply: provider.applyRecently!)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
