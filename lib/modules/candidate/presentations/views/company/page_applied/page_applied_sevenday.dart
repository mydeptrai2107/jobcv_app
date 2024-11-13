import 'package:app/configs/image_factory.dart';
import 'package:app/modules/candidate/data/models/apply_model.dart';
import 'package:app/modules/candidate/data/models/user_model.dart';
import 'package:app/shared/provider/provider_apply.dart';
import 'package:app/modules/candidate/domain/providers/provider_auth.dart';
import 'package:app/shared/provider/provider_recruitment.dart';
import 'package:app/modules/candidate/presentations/views/company/page_applied/widgets/item_recruitment_applied.dart';
import 'package:app/shared/models/recruitment_like_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PageAppliedSevenDay extends StatefulWidget {
  const PageAppliedSevenDay({super.key});

  @override
  State<PageAppliedSevenDay> createState() => _PageAppliedSevenDayState();
}

class _PageAppliedSevenDayState extends State<PageAppliedSevenDay> {
  List<Apply> list = [];
  List<RecruitmentLike> listRecruit = [];
  bool isLoading = false;
  UserModel user = Modular.get<ProviderAuth>().user;

  initData() async {
    setState(() {
      isLoading = true;
    });
    list = await Modular.get<ProviderApply>().getListApply7Day(user.userId);
    for (int i = 0; i < list.length; i++) {
      RecruitmentLike recruitment = await Modular.get<ProviderRecruitment>()
          .getRecruitById(list[i].recruitmentId);
      listRecruit.add(recruitment);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    context.watch<ProviderAuth>();
    context.watch<ProviderApply>();
    context.watch<ProviderRecruitment>();

    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : listRecruit.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(ImageFactory.box),
                            fit: BoxFit.fill)),
                  ),
                  const Text(
                    'Danh sách tin tuyển dụng trống',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  )
                ],
              )
            : Container(
                height: size.height,
                width: size.width,
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      return ItemRecruitApplied(
                          recruitment: listRecruit[index].recruitment,
                          statusCV: list[index].statusApply,
                          idApply: list[index].id);
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 15,
                        ),
                    itemCount: listRecruit.length),
              );
  }
}
