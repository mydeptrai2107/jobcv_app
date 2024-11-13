import 'package:app/configs/route_path.dart';
import 'package:app/modules/candidate/presentations/views/company/page_applied/page_applied_allday.dart';
import 'package:app/modules/candidate/presentations/views/company/page_applied/page_applied_sevenday.dart';
import 'package:app/modules/candidate/presentations/views/company/page_applied/page_applied_thirtyday.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppliedScreen extends StatefulWidget {
  const AppliedScreen({super.key});

  @override
  State<AppliedScreen> createState() => _AppliedScreenState();
}

class _AppliedScreenState extends State<AppliedScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Việc đã ứng tuyển'),
          bottom: const TabBar(tabs: [
            Tab(
              text: '7 ngày',
            ),
            Tab(
              text: '30 ngày',
            ),
            Tab(
              text: 'Tất cả',
            )
          ]),
          leading: IconButton(
              onPressed: () {
                Modular.to.navigate(RoutePath.home);
              },
              icon: const Icon(Icons.arrow_back)),
        ),
        body: const TabBarView(
          children: [
            PageAppliedSevenDay(),
            PageAppliedThirtyDay(),
            PageAppliedAllDay()
          ],
        ),
      ),
    );
  }
}
