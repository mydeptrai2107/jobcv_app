import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:app/configs/route_path.dart';
import 'package:app/modules/candidate/presentations/themes/color.dart';
import 'package:app/modules/recruiter/data/provider/recruitment_provider.dart';

class DetailRecruitmentScreen extends StatelessWidget {
  const DetailRecruitmentScreen({super.key});

  _removeRecruitment(String id) {
    showDialog(
        context: Modular.routerDelegate.navigatorKey.currentContext!,
        builder: (_) => AlertDialog(
              title: const Text('Bạn có muốn xoá tin này ?'),
              titleTextStyle:
                  const TextStyle(fontSize: 18, color: Colors.black),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 0, minimumSize: const Size(100, 40)),
                          onPressed: () => Modular.to.pop(),
                          child: const Text('Huỷ'))),
                  Flexible(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 0, minimumSize: const Size(100, 40)),
                          onPressed: () async {
                            await Modular.get<RecruitmentProvider>()
                                .deleteRecruitment(id);
                            Modular.to.pop();
                          },
                          child: const Text('Xoá'))),
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final item = context.watch<RecruitmentProvider>().showDetailRecruitment!;
    return Scaffold(
      appBar: AppBar(actions: [
        Row(
          children: [
            const SizedBox(width: 8.0),
            GestureDetector(
              onTap: () => Modular.to
                  .pushNamed(RoutePath.addRecruitment, arguments: item),
              child: Container(
                height: 40,
                width: 40,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(6.0)),
                child: const Icon(
                  Icons.edit_document,
                  color: primaryColor,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 12.0),
            GestureDetector(
              onTap: () => _removeRecruitment(item.id!),
              child: Container(
                height: 40,
                width: 40,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(6.0)),
                child: const Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(
              width: 16.0,
            )
          ],
        ),
      ]),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title!,
                style: textTheme.headlineLarge!
                    .copyWith(fontWeight: FontWeight.bold, color: Colors.amber),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Vị trí : ${item.position!}',
                    style: textTheme.headlineSmall!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await context
                          .read<RecruitmentProvider>()
                          .updateStatus(item);
                    },
                    child: Container(
                      height: 30,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(6.0)),
                      child: Text(
                        item.statusShow == false ? 'Đang tắt' : 'Đang bật',
                        style: textTheme.bodySmall!.copyWith(
                            color: item.statusShow == false
                                ? Colors.red
                                : primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: Colors.white),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.attach_money),
                          Text(item.salary!),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: Colors.white),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.people),
                            const SizedBox(width: 8.0),
                            Text(item.numberOfRecruits!),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        color: Colors.white),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.work_history),
                        const SizedBox(width: 8.0),
                        Text(item.experience!),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: Colors.white),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.business_outlined),
                          const SizedBox(width: 8.0),
                          Text('${item.address}, Việt Nam'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mô tả công việc',
                      style: textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold, color: primaryColor),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      item.descriptionWorking!,
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Colors.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Yêu cầu công việc',
                        style: textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold, color: primaryColor),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        item.request!,
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quyền lợi',
                      style: textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold, color: primaryColor),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      item.benefit!,
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30.0)
            ],
          ),
        ),
      ),
    );
  }
}
