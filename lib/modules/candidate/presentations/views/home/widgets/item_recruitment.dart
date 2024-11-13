// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:app/configs/image_factory.dart';
import 'package:app/configs/route_path.dart';
import 'package:app/modules/candidate/data/models/company_model.dart';
import 'package:app/modules/candidate/data/models/user_model.dart';
import 'package:app/modules/candidate/domain/providers/provider_auth.dart';
import 'package:app/shared/provider/provider_recruitment.dart';
import 'package:app/shared/models/recruitment_model.dart';
import 'package:app/modules/candidate/data/repositories/company_repositories.dart';
import 'package:app/shared/provider/provider_company.dart';
import 'package:app/modules/candidate/presentations/themes/color.dart';
import 'package:app/shared/utils/notiface_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class ItemRecuitment extends StatefulWidget {
  ItemRecuitment(
      {super.key,
      required this.recruitment,
      this.marginHorizontal,
      this.onLoading,
      this.loadCount});
  final Recruitment recruitment;
  double? marginHorizontal;
  VoidCallback? onLoading;
  VoidCallback? loadCount;

  @override
  State<ItemRecuitment> createState() => _ItemRecuitmentState();
}

class _ItemRecuitmentState extends State<ItemRecuitment> {
  Company company = Company(
      name: '',
      contact: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      avatar: '',
      info: '',
      intro: '',
      address: '',
      id: '');

    UserModel user = Modular.get<ProviderAuth>().user;
  

  @override
  void initState() {
    initData();
    super.initState();
  }

  initData() async {
    company = await Modular.get<ProviderCompany>()
        .getCompanyById(widget.recruitment.companyId);

    listIdSaved = await Modular.get<ProviderRecruitment>()
        .getListIdRecruitmentSaved(user.userId);
    isLike = listIdSaved.contains(widget.recruitment.id);
  }

  bool isLike = false;

  List<String> listIdSaved = [];

  @override
  Widget build(BuildContext context) {
    context.watch<ProviderCompany>();
    final Size size = MediaQuery.of(context).size;
    final providerRecruitment = context.watch<ProviderRecruitment>();
    context.watch<ProviderAuth>();
    return GestureDetector(
      onTap: () {
        Modular.to.pushNamed(RoutePath.detailRecruitment,
            arguments: [widget.recruitment, company]);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: widget.marginHorizontal ?? 15),
        padding: const EdgeInsets.all(15),
        width: size.width,
        //height: 220,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 15),
                  height: size.width / 7,
                  width: size.width / 7,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      image: company.avatar == '' || company.avatar == null
                          ? const DecorationImage(
                              image: AssetImage(ImageFactory.editCV))
                          : DecorationImage(
                              image: NetworkImage(
                                  CompanyRepository.getAvatar(company.avatar!)),
                              fit: BoxFit.fill),
                      border: Border.all(width: 0.3, color: Colors.grey),
                      boxShadow: const [
                        BoxShadow(color: Colors.grey, offset: Offset(1, 1))
                      ]),
                ),
                SizedBox(
                  height: size.width / 7,
                  width: size.width - (size.width / 7) - 120,
                  child: Text(
                    widget.recruitment.title!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
                Expanded(child: Container()),
                GestureDetector(
                  onTap: () async {
                    try {                 
                      await providerRecruitment.actionSave(
                          widget.recruitment.id!, user.userId, true);
                      isLike = !isLike;
                    } catch (e) {
                      notifaceError(
                          context, jsonDecode(e.toString())['message']);
                    }
                    if (widget.loadCount != null) widget.loadCount!();
                    if (widget.onLoading != null) widget.onLoading!();
                  },
                  child: Icon(
                    isLike ? Icons.bookmark : Icons.bookmark_outline,
                    color: isLike ? primaryColor : Colors.black,
                    size: 30,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              company.name,
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    widget.recruitment.address!,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(
                  width: 7,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    widget.recruitment.experience!,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 7),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SvgPicture.asset(
                        ImageFactory.dollarSignBag,
                        color: primaryColor,
                        width: 15,
                        height: 15,
                      ),
                      Text(
                        widget.recruitment.salary!,
                        style: const TextStyle(
                            fontSize: 13,
                            color: primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(child: Container())
              ],
            ),
            const Divider(
              thickness: 1,
            ),
            Row(
              children: [
                SvgPicture.asset(
                  ImageFactory.clock,
                  width: 17,
                  height: 17,
                ),
                Text(
                  formatDuration((widget.recruitment.deadline!)
                      .difference(DateTime.now())),
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    return duration.inDays > 0
        ? " Còn ${twoDigits(duration.inDays)} ngày để ứng tuyển"
        : " Quá thời hạn ứng tuyển";
  }
}
