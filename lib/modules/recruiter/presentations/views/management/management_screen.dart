import 'package:app/configs/image_factory.dart';
import 'package:app/modules/candidate/data/models/apply_model.dart';
import 'package:app/modules/recruiter/data/provider/recruiter_provider.dart';
import 'package:app/modules/recruiter/data/provider/recruitment_provider.dart';
import 'package:app/modules/recruiter/presentations/views/management/widgets/item_cv_widget.dart';
import 'package:app/shared/provider/provider_apply.dart';
import 'package:flutter/material.dart';
import 'package:app/modules/recruiter/presentations/widgets/search_box.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ManagementScreen extends StatefulWidget {
  const ManagementScreen({super.key});

  @override
  State<ManagementScreen> createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen> {
  final TextEditingController textEditingController = TextEditingController();
  List<Apply> applys = [];
  List<Apply> listPass = [];
  List<Apply> listMiss = [];
  List<Apply> list = [];

  initData() async {
    list = await Modular.get<ProviderApply>()
        .getListApplyByComapny(Modular.get<RecruiterProvider>().recruiter.id);
    list.map((e) {
      if (e.statusApply == 1) applys.add(e);
    }).toList();
    list.map((e) {
      if (e.statusApply == 2) listPass.add(e);
    }).toList();
    list.map((e) {
      if (e.statusApply == 0) listMiss.add(e);
    }).toList();
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<ProviderApply>();
    context.watch<RecruiterProvider>();
    context.watch<RecruitmentProvider>();
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: SearchBox(
                hinText: 'Tìm kiếm tên',
                callback: () async {
                  await context
                      .read<RecruitmentProvider>()
                      .searchListCV(textEditingController.text);
                },
                closeSearch: () async {
                  textEditingController.clear();
                  await context
                      .read<RecruitmentProvider>()
                      .searchListCV(textEditingController.text);
                },
                textEditingController: textEditingController,
              ),
            ),
            bottom: const TabBar(tabs: [
              Tab(
                text: 'Vừa nhận',
              ),
              Tab(
                text: 'Phê duyệt',
              ),
              Tab(
                text: 'Loại',
              )
            ])),
        body: TabBarView(
          children: [
            justReceived(context),
            pass(context),
            miss(context),
          ],
        ),
      ),
    );
  }

  Widget justReceived(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return applys.isEmpty
        ? SizedBox(
            width: size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(ImageFactory.searchNotFound),
                          fit: BoxFit.fill)),
                ),
                const Text(
                  'Chưa có ứng viên ứng tuyển',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                )
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Builder(
                    builder: (_) {
                      return GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        children: List.generate(applys.length, (index) {
                          final item = applys[index];
                          return ItemCV(
                            apply: item,
                            onApply: () async {
                              applys.clear();
                              listMiss.clear();
                              listPass.clear();
                              await initData();
                              setState(() {});
                              print('3sssssssssssssssss');
                            },
                          );
                        }),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }

  Widget pass(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return listPass.isEmpty
        ? SizedBox(
            width: size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ImageFactory.searchNotFound),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const Text(
                  'Không tìm thấy dữ liệu',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                )
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Builder(
                    builder: (_) {
                      return GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        children: List.generate(
                          listPass.length,
                          (index) {
                            final item = listPass[index];
                            return ItemCV(
                              apply: item,
                              onApply: () async {
                                listMiss.clear();
                                listPass.clear();
                                await initData();
                                setState(() {});
                                print('2sssssssssssssssss');
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }

  Widget miss(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return listMiss.isEmpty
        ? SizedBox(
            width: size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ImageFactory.searchNotFound),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const Text(
                  'Không tìm thấy dữ liệu',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                )
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Builder(
                    builder: (_) {
                      return GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        children: List.generate(
                          listMiss.length,
                          (index) {
                            final item = listMiss[index];
                            return ItemCV(
                              apply: item,
                              onApply: () async {
                                listMiss.clear();
                                listPass.clear();
                                await initData();
                                setState(() {});
                                print('1sssssssssssssssss');
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }
}
