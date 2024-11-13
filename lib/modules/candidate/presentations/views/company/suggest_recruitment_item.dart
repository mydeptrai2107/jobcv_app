// ignore_for_file: deprecated_member_use

import 'package:app/configs/image_factory.dart';
import 'package:app/configs/route_path.dart';
import 'package:app/modules/candidate/data/models/company_model.dart';
import 'package:app/modules/candidate/data/repositories/company_repositories.dart';
import 'package:app/shared/provider/provider_company.dart';
import 'package:app/shared/models/recruitment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SuggestRecruitmentItem extends StatefulWidget {
  const SuggestRecruitmentItem({super.key, required this.recruitment});
  final Recruitment recruitment;

  @override
  State<SuggestRecruitmentItem> createState() => _SuggestRecruitmentItemState();
}

class _SuggestRecruitmentItemState extends State<SuggestRecruitmentItem> {
  Company company = Company(
      name: '',
      contact: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      id: '');

  initData() async {
    company = await Modular.get<ProviderCompany>()
        .getCompanyById(widget.recruitment.companyId);
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    context.watch<ProviderCompany>();

    return GestureDetector(
      onTap: () {
        Modular.to.pushNamed(RoutePath.detailRecruitment,
            arguments: [widget.recruitment, company]);
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(right: 10),
        height: 200,
        width: size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.grey,
                      image: company.avatar == '' || company.avatar == null
                          ? const DecorationImage(
                              image: AssetImage(ImageFactory.editCV))
                          : DecorationImage(
                              image: NetworkImage(CompanyRepository.getAvatar(
                                  company.avatar.toString())),
                              fit: BoxFit.cover)),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "${widget.recruitment.title}",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 245, 236, 255),
                      borderRadius: BorderRadius.circular(50)),
                  child: Text(
                    widget.recruitment.workingForm ?? "Chưa cập nhật",
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 108, 76, 190)),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 116, 86)
                          .withOpacity(0.05),
                      borderRadius: BorderRadius.circular(50)),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        ImageFactory.location1,
                        width: 14,
                        height: 14,
                        color: const Color.fromARGB(255, 0, 116, 86),
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      Text(widget.recruitment.address.toString(),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 0, 116, 86),
                          )),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 116, 86)
                          .withOpacity(0.05),
                      borderRadius: BorderRadius.circular(50)),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        ImageFactory.dollarSignBag,
                        width: 14,
                        height: 14,
                        color: const Color.fromARGB(255, 0, 116, 86),
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      Text(widget.recruitment.salary.toString(),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 0, 116, 86),
                          )),
                    ],
                  ),
                ),
                Expanded(child: Container())
              ],
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
