import 'package:app/modules/candidate/presentations/themes/color.dart';
import 'package:app/modules/recruiter/data/provider/recruitment_provider.dart';
import 'package:app/shared/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ionicons/ionicons.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});
  void _remove(BuildContext context, String id) {
    context.read<RecruitmentProvider>().removeNotification(id);
  }

  @override
  Widget build(BuildContext context) {
    // final list = context
    //     .watch<NotificationProvider>((p) => p.remoteMessage)
    //     .remoteMessage;
    final list = context
        .watch<RecruitmentProvider>((p) => p.notifications)
        .notifications;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 41, 63, 78),
        title: const Text(
          'Thông báo',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: list.isEmpty
          ? const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Ionicons.notifications_outline),
                  Text('Không có thông báo nào cả !')
                ],
              ),
            )
          : ListView.separated(
              itemCount: 10,
              itemBuilder: (_, index) {
                final item = list[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  child: Slidable(
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        Expanded(
                          flex: 1,
                          child: SizedBox.expand(
                            child: OutlinedButton(
                              onPressed: () => _remove(_, item.idRecruitment),
                              style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  side: BorderSide.none,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide.none,
                                      borderRadius: BorderRadius.circular(10))),
                              child: const Text('Xóa thông báo'),
                            ),
                          ),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tin tuyển dụng hết hạn',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('Tiêu đề : ${item.title}'),
                            Text(
                                'Hết hạn vào : ${Format.formatDateTimeToYYYYmmdd(item.deadline)}'),
                          ],
                        ),
                        const Icon(
                          Ionicons.newspaper_outline,
                          size: 45,
                          color: primaryColor,
                        )
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider()),
    );
  }
}
