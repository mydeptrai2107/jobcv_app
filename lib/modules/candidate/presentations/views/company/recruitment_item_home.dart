// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:app/configs/image_factory.dart';
import 'package:app/configs/route_path.dart';
import 'package:app/modules/candidate/data/models/company_model.dart';
import 'package:app/modules/candidate/data/models/user_model.dart';
import 'package:app/modules/candidate/data/repositories/company_repositories.dart';
import 'package:app/modules/candidate/domain/providers/provider_auth.dart';
import 'package:app/shared/provider/provider_company.dart';
import 'package:app/shared/provider/provider_recruitment.dart';
import 'package:app/modules/candidate/presentations/themes/color.dart';
import 'package:app/shared/models/recruitment_model.dart';
import 'package:app/shared/utils/notiface_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RecruitmentItemHome extends StatefulWidget {
  const RecruitmentItemHome({super.key, required this.recruitment});
  final Recruitment recruitment;

  @override
  State<RecruitmentItemHome> createState() => _RecruitmentItemHomeState();
}

class _RecruitmentItemHomeState extends State<RecruitmentItemHome> {
  Company company = Company(
      name: '',
      contact: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      id: '');

  UserModel user = Modular.get<ProviderAuth>().user;

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
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    context.watch<ProviderCompany>();
    context.watch<ProviderAuth>();

    final providerRecruitment = context.watch<ProviderRecruitment>();
    return GestureDetector(
      onTap: () {
        Modular.to.pushNamed(RoutePath.detailRecruitment,
            arguments: [widget.recruitment, company]);
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(right: 10),
        height: 180,
        width: size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey,
                      image: company.avatar == '' || company.avatar == null
                          ? const DecorationImage(
                              image: AssetImage(ImageFactory.editCV))
                          : DecorationImage(
                              image: NetworkImage(CompanyRepository.getAvatar(
                                  company.avatar.toString())))),
                ),
                Text(
                  "${widget.recruitment.salary} / Tháng",
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w400),
                )
              ],
            ),
            SizedBox(
              height: 47,
              child: Text(
                widget.recruitment.title!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            Text(
              company.name,
              maxLines: 1,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.grey[200]),
                  child: Text(
                    widget.recruitment.workingForm!,
                    style: const TextStyle(color: primaryColor, fontSize: 13),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  margin: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.grey[200]),
                  child: Text(
                    widget.recruitment.address!,
                    style: const TextStyle(color: primaryColor, fontSize: 13),
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
                  },
                  child: isLike
                      ? SvgPicture.asset(
                          ImageFactory.bookmark,
                          width: 23,
                          height: 20,
                          color: primaryColor,
                        )
                      : SvgPicture.asset(
                          ImageFactory.bookmarkoutline,
                          width: 23,
                          height: 20,
                        ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
