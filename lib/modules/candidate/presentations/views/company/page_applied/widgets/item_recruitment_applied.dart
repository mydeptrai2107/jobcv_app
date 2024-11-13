// ignore_for_file: deprecated_member_use

import 'package:app/configs/image_factory.dart';
import 'package:app/configs/route_path.dart';
import 'package:app/configs/uri.dart';
import 'package:app/modules/candidate/data/models/company_model.dart';
import 'package:app/modules/candidate/data/models/profile_model.dart';
import 'package:app/modules/candidate/data/repositories/company_repositories.dart';
import 'package:app/modules/candidate/domain/providers/provider_auth.dart';
import 'package:app/shared/provider/provider_apply.dart';
import 'package:app/shared/provider/provider_company.dart';
import 'package:app/modules/candidate/presentations/themes/color.dart';
import 'package:app/modules/candidate/presentations/views/company/widgets/tag_recuitment_item.dart';
import 'package:app/shared/models/recruitment_model.dart';
import 'package:app/shared/utils/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ItemRecruitApplied extends StatefulWidget {
  const ItemRecruitApplied(
      {super.key,
      required this.recruitment,
      required this.statusCV,
      required this.idApply});

  final Recruitment recruitment;
  final int statusCV;
  final String idApply;

  @override
  State<ItemRecruitApplied> createState() => _ItemRecruitAppliedState();
}

class _ItemRecruitAppliedState extends State<ItemRecruitApplied> {
  Company company = Company(
      name: '',
      contact: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      id: '');

  Profile? profile;

  initData() async {
    if (widget.recruitment.id != '') {
      company = await Modular.get<ProviderCompany>()
          .getCompanyById(widget.recruitment.companyId);
      profile =
          await Modular.get<ProviderApply>().getProfileApplied(widget.idApply);
    }
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
    context.watch<ProviderAuth>();
    return widget.recruitment.id == ''
        ? Container(
            width: size.width,
            height: 190.h,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: const Center(
                child: Text(
              'Bài tuyển dụng không tồn tại hoặc đã bị xóa',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            )),
          )
        : Container(
            width: size.width,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(10),
                        image: company.avatar == '' || company.avatar == null
                            ? const DecorationImage(
                                image: AssetImage(ImageFactory.editCV))
                            : DecorationImage(
                                image: NetworkImage(CompanyRepository.getAvatar(
                                    company.avatar!))),
                      ),
                    ),
                    SizedBox(
                      height: 80,
                      width: size.width - 140,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.recruitment.title} - ${widget.recruitment.address}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            company.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        TagRecuitmentItem(
                          icon: ImageFactory.clock,
                          title: Format.formatDateTimeToYYYYmmdd(
                              widget.recruitment.deadline!),
                        ),
                        SizedBox(
                          height: 7.h,
                        ),
                        TagRecuitmentItem(
                          icon: ImageFactory.location,
                          title: widget.recruitment.address!,
                        )
                      ],
                    ),
                    TagRecuitmentItem(
                        title: widget.recruitment.salary!,
                        icon: ImageFactory.dollar)
                  ],
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                        child: GestureDetector(
                      onTap: () async {
                        // String? encodeQueryParameters(Map<String, String> params) {
                        //   return params.entries
                        //       .map((MapEntry<String, String> e) =>
                        //           '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                        //       .join('&');
                        // }

                        // final Uri emailLaunchUri = Uri(
                        //   scheme: 'mailto',
                        //   path: company.contact,
                        //   query: encodeQueryParameters(<String, String>{
                        //     'subject': 'Example Subject & Symbols are allowed!',
                        //   }),
                        // );

                        // try {
                        //   await launchUrl(emailLaunchUri);
                        // } catch (e) {
                        //   notifaceError(context, jsonDecode(e.toString())['message']);
                        // }

                        Modular.to.pushNamed(RoutePath.chatScreen, arguments: [
                          Modular.get<ProviderAuth>().user.userId,
                          company.id,
                          company.name,
                          getAvatarCompany(company.avatar.toString())
                        ]);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(ImageFactory.chat,
                                color: primaryColor, width: 20, height: 20),
                            const Text(
                              '  Gởi tin nhắn',
                              style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    )),
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        Modular.to.pushNamed(RoutePath.pdfViewer, arguments: [
                          profile?.name ?? '',
                          profile?.pathCv ?? '',
                          false,
                          widget.idApply
                        ]);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        decoration: BoxDecoration(
                            color: Colors.grey[350],
                            borderRadius: BorderRadius.circular(5)),
                        child: const Center(
                            child: Text(
                          'Xem lại CV',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )),
                      ),
                    ))
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                const Divider(
                  thickness: 1,
                ),
                statusCV(widget.statusCV, size)
              ],
            ),
          );
  }

  Widget statusCV(int status, Size size) {
    if (status == 1) {
      return Container(
          width: size.width,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: purple100,
          ),
          child: const Text(
            'CV của bạn đang được xử lý',
            style: TextStyle(
                color: purple, fontSize: 15, fontWeight: FontWeight.w400),
          ));
    } else if (status == 2) {
      return Container(
          width: size.width,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: purple100,
          ),
          child: const Text(
            'CV của bạn đã phê duyệt, xin đợi tin nhắn từ nhà tuyển dụng',
            style: TextStyle(
                color: purple, fontSize: 15, fontWeight: FontWeight.w400),
          ));
    } else {
      return Container(
          width: size.width,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: purple100,
          ),
          child: const Text(
            'CV của bạn không đạt yêu cầu',
            style: TextStyle(
                color: purple, fontSize: 15, fontWeight: FontWeight.w400),
          ));
    }
  }
}
