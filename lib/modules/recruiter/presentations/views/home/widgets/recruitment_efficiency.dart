import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:app/modules/recruiter/data/provider/recruitment_provider.dart';
import 'package:app/shared/models/recruitment_model.dart';

class RecruitmentEfficiency extends StatelessWidget {
  final List<Recruitment> list;
  const RecruitmentEfficiency({
    Key? key,
    required this.list,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hiệu quả tuyển dụng',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Builder(builder: (_) {
                final value =
                    _.watch<RecruitmentProvider>((p) => p.totalShow).totalShow;
                return ElementWidget(
                  label: 'Tin tuyển dụng hiển thị',
                  color: Colors.orange.shade400,
                  quantity: value,
                );
              }),
            ),
            const SizedBox(
              width: 16.0,
            ),
            Builder(builder: (_) {
              final value = _
                  .watch<RecruitmentProvider>((p) => p.listApply)
                  .listApply
                  .length;
              return ElementWidget(
                label: 'CV tiếp nhận',
                color: Colors.green,
                quantity: value,
              );
            }),
            const SizedBox(height: 6),
          ],
        )
      ],
    );
  }
}

class ElementWidget extends StatelessWidget {
  final String label;
  final Color color;
  final int quantity;
  const ElementWidget({
    super.key,
    required this.label,
    required this.color,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(4)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          quantity.toString(),
          style: TextStyle(color: color),
        ),
        const SizedBox(height: 8.0),
        Text(
          label,
          style: TextStyle(color: color),
        ),
      ]),
    );
  }
}
