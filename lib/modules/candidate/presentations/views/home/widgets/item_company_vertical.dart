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
import 'package:app/shared/utils/notiface_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ItemCompanyVertical extends StatefulWidget {
  const ItemCompanyVertical({super.key, required this.company});

  final Company company;

  @override
  State<ItemCompanyVertical> createState() => _ItemCompanyVerticalState();
}

class _ItemCompanyVerticalState extends State<ItemCompanyVertical> {
  int quantityRecruit = 0;

  bool isLike = false;

  List<String> listIdSaved = [];

  @override
  void initState() {
    super.initState();
    initData();
  }

    UserModel user = Modular.get<ProviderAuth>().user;


  initData() async {
    quantityRecruit = await Modular.get<ProviderRecruitment>()
        .getQuantityRecruitByCompany(widget.company.id);

    listIdSaved =
        await Modular.get<ProviderCompany>().getListIdCompanySaved(user.userId);
    isLike = listIdSaved.contains(widget.company.id);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    context.watch<ProviderRecruitment>();
    context.watch<ProviderAuth>();

    final providerCompany = context.watch<ProviderCompany>();
    return GestureDetector(
      onTap: () {
        Modular.to
            .pushNamed(RoutePath.homeCompany, arguments: [widget.company]);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        height: 200,
        width: size.width / 2,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      image: widget.company.avatar == '' ||
                              widget.company.avatar == null
                          ? const DecorationImage(
                              image: AssetImage(ImageFactory.editCV))
                          : DecorationImage(
                              image: NetworkImage(CompanyRepository.getAvatar(
                                  widget.company.avatar!))),
                      border: Border.all(width: 0.3, color: Colors.grey),
                      boxShadow: const [
                        BoxShadow(color: Colors.grey, offset: Offset(1, 1))
                      ]),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: size.width / 9,
              child: Text(
                widget.company.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$quantityRecruit việc làm',
                style: const TextStyle(fontSize: 14),
              ),
            ),
            GestureDetector(
              onTap: () async {
                try {
                  await providerCompany.actionSave(
                      widget.company.id, user.userId, true);
                  isLike = !isLike;
                } catch (e) {
                  notifaceError(context, jsonDecode(e.toString())['message']);
                }
              },
              child: Container(
                margin: const EdgeInsets.only(top: 5),
                padding: const EdgeInsets.symmetric(vertical: 3),
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 0.5, color: isLike ? Colors.grey : primaryColor),
                    borderRadius: BorderRadius.circular(100)),
                child: Center(
                  child: isLike
                      ? const Text(
                          'Đang theo dõi',
                          style: TextStyle(fontSize: 13, color: Colors.black),
                        )
                      : const Text(
                          '+ Theo dõi',
                          style: TextStyle(fontSize: 13, color: primaryColor),
                        ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
