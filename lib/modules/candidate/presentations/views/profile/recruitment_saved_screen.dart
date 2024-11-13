import 'package:app/modules/candidate/data/models/user_model.dart';
import 'package:app/modules/candidate/domain/providers/provider_auth.dart';
import 'package:app/shared/provider/provider_recruitment.dart';
import 'package:app/modules/candidate/presentations/views/home/widgets/item_recruitment.dart';
import 'package:app/shared/models/recruitment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RecruitmentSavedScreen extends StatefulWidget {
  const RecruitmentSavedScreen({super.key, required this.loadCount});

  final VoidCallback loadCount;

  @override
  State<RecruitmentSavedScreen> createState() => _RecruitmentSavedScreenState();
}

class _RecruitmentSavedScreenState extends State<RecruitmentSavedScreen> {
  List<Recruitment> list = [];
  UserModel user = Modular.get<ProviderAuth>().user;


  initData() async {
    list = await Modular.get<ProviderRecruitment>()
        .getListRecruitmentSaved(user.userId);
    setState(() {});
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final providerRecruitment = context.watch<ProviderRecruitment>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Việc làm đang quan tâm'),
      ),
      body: providerRecruitment.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SizedBox(
              height: size.height,
              width: size.width,
              child: ListView.separated(
                  itemBuilder: (context, index) => ItemRecuitment(
                        recruitment: list[index],
                        onLoading: initData,
                        loadCount: widget.loadCount,
                      ),
                  separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ),
                  itemCount: list.length)),
    );
  }
}
