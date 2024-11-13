// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:app/configs/font_style_text.dart';
import 'package:app/configs/image_factory.dart';
import 'package:app/configs/route_path.dart';
import 'package:app/configs/uri.dart';
import 'package:app/modules/candidate/data/models/company_model.dart';
import 'package:app/modules/candidate/data/models/user_model.dart';
import 'package:app/modules/candidate/data/repositories/company_repositories.dart';
import 'package:app/modules/candidate/domain/providers/provider_auth.dart';
import 'package:app/shared/provider/provider_apply.dart';
import 'package:app/shared/provider/provider_recruitment.dart';
import 'package:app/modules/candidate/presentations/themes/color.dart';
import 'package:app/modules/candidate/presentations/views/company/widgets/info_recuitment_item.dart';
import 'package:app/modules/candidate/presentations/views/company/widgets/tag_info_widget.dart';
import 'package:app/modules/candidate/presentations/views/home/widgets/item_recruitment.dart';
import 'package:app/modules/candidate/presentations/views/widgets/button_app.dart';
import 'package:app/shared/models/recruitment_like_model.dart';
import 'package:app/shared/models/recruitment_model.dart';
import 'package:app/shared/utils/notiface_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailRecruitment extends StatefulWidget {
  const DetailRecruitment(
      {super.key, required this.recruitment, required this.company});

  final Recruitment recruitment;
  final Company company;

  @override
  State<DetailRecruitment> createState() => _DetailRecruitmentState();
}

class _DetailRecruitmentState extends State<DetailRecruitment> {
  @override
  void initState() {
    initData();
    super.initState();
  }

  UserModel user = Modular.get<ProviderAuth>().user;

  bool isLike = false;
  List<String> listIdSaved = [];

  bool checkApplied = false;
  int countDayApplied = 0;

  // true: thong tin | false : Cong ty
  bool isChoose = true;

  List<RecruitmentLike> recruitements = [];
  int numberPaging = 1;

  initData() async {
    recruitements = await Modular.get<ProviderRecruitment>()
        .getListRecruitByCompanyPaging(widget.company.id, numberPaging);
    checkApplied = await Modular.get<ProviderApply>()
        .checkRecruitmentApplied(widget.recruitment.id!, user.userId);
    countDayApplied = await Modular.get<ProviderApply>()
        .countDayApplied(widget.recruitment.id!, user.userId);
    listIdSaved = await Modular.get<ProviderRecruitment>()
        .getListIdRecruitmentSaved(user.userId);
    isLike = listIdSaved.contains(widget.recruitment.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final providerRecruitment = context.watch<ProviderRecruitment>();
    context.watch<ProviderAuth>();

    context.watch<ProviderApply>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chi tiết việc làm',
          style: textStyleTitleAppBar,
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              try {
                await providerRecruitment.actionSave(
                    widget.recruitment.id!, user.userId, true);
                isLike = !isLike;
              } catch (e) {
                notifaceError(context, jsonDecode(e.toString())['message']);
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
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(right: 10.h, left: 10, bottom: 5),
              width: size.width,
              child: Column(
                children: [
                  Container(
                    height: 80.h,
                    width: 80.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        image: widget.company.avatar == '' ||
                                widget.company.avatar == null
                            ? const DecorationImage(
                                image: AssetImage(ImageFactory.editCV),
                                fit: BoxFit.cover)
                            : DecorationImage(
                                image: NetworkImage(CompanyRepository.getAvatar(
                                    widget.company.avatar!)),
                                fit: BoxFit.cover)),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    alignment: AlignmentDirectional.bottomStart,
                    child: Center(
                      child: Text(
                        '${widget.recruitment.title!.toUpperCase()} - ${widget.recruitment.address!.toUpperCase()}',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  Container(
                    alignment: AlignmentDirectional.topStart,
                    width: size.width - 100.h,
                    child: Center(
                      child: Text(
                        widget.company.name.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withOpacity(0.5)),
                      ),
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  SizedBox(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isChoose = !isChoose;
                            });
                          },
                          child: Text(
                            'Thông tin',
                            style: TextStyle(
                                color: isChoose ? primaryColor : Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                decorationColor:
                                    isChoose ? primaryColor : Colors.black,
                                decoration: isChoose
                                    ? TextDecoration.underline
                                    : TextDecoration.none),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isChoose = !isChoose;
                            });
                          },
                          child: Text(
                            'Công ty',
                            style: TextStyle(
                                color: !isChoose ? primaryColor : Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                decorationColor:
                                    !isChoose ? primaryColor : Colors.black,
                                decoration: !isChoose
                                    ? TextDecoration.underline
                                    : TextDecoration.none),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            isChoose
                ? buildInfoRecruitment(size)
                : buildInfoCompany(size, recruitements)
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        height: 50.h,
        width: size.width,
        color: Colors.white,
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
                flex: 4,
                child: ButtonApp(
                  height: 38,
                  backGroundColor: countDayApplied >= 0 && countDayApplied <= 6
                      ? Colors.grey
                      : primaryColor,
                  onPress: () {
                    if (countDayApplied == -1) {
                      Modular.to.pushNamed(RoutePath.applyScreen,
                          arguments: [widget.recruitment, widget.company.id]);
                    }
                  },
                  title: checkApplied
                      ? countDayApplied <= 6
                          ? "Đã ứng tuyển"
                          : "Ứng tuyển lại"
                      : 'Ứng tuyển ngay',
                  borderRadius: 100,
                )),
            Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        String? encodeQueryParameters(
                            Map<String, String> params) {
                          return params.entries
                              .map((MapEntry<String, String> e) =>
                                  '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                              .join('&');
                        }

                        final Uri emailLaunchUri = Uri(
                          scheme: 'mailto',
                          path: widget.company.contact,
                          query: encodeQueryParameters(<String, String>{
                            'subject': 'Example Subject & Symbols are allowed!',
                          }),
                        );

                        try {
                          await launchUrl(emailLaunchUri);
                        } catch (e) {
                          notifaceError(
                              context, jsonDecode(e.toString())['message']);
                        }
                      },
                      child: SvgPicture.asset(
                        ImageFactory.gmailIcon,
                        width: 22,
                        height: 22,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        Modular.to.pushNamed(RoutePath.chatScreen, arguments: [
                          Modular.get<ProviderAuth>().user.userId,
                          widget.company.id,
                          widget.company.name,
                          getAvatarCompany(widget.company.avatar.toString())
                        ]);
                      },
                      child: SvgPicture.asset(
                        ImageFactory.chat,
                        width: 22,
                        height: 22,
                        color: primaryColor,
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Widget buildInfoCompany(Size size, List<RecruitmentLike> recruitments) {
    return Expanded(
        child: Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      width: size.width,
      child: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.only(
                left: 15.w, right: 15.w, top: 20.h, bottom: 20.h),
            margin: const EdgeInsets.only(bottom: 25, top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.company.name.toUpperCase(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w900, fontSize: 18),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(255, 185, 247, 193)),
                      height: 35.h,
                      width: 35.h,
                      child: SvgPicture.asset(
                        ImageFactory.locationColor,
                        color: primaryColor,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Địa chỉ công ty',
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          width: size.width - 110,
                          child: Text(
                            widget.company.address ?? 'Chưa cập nhật',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                            width: size.width - 110,
                            child: const Divider(
                              thickness: 1,
                            )),
                      ],
                    )
                  ],
                ),

                const SizedBox(
                  height: 10,
                ),
                //website company
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(255, 185, 247, 193)),
                      height: 35.h,
                      width: 35.h,
                      child: SvgPicture.asset(
                        ImageFactory.earth,
                        color: primaryColor,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Website công ty:',
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          width: size.width - 110,
                          child: Text(
                            widget.company.info ?? '',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'GIỚI THIỆU CÔNG TY',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  widget.company.intro.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          const Divider(
            thickness: 1,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: Text(
              'Việc làm cùng công ty',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
            ),
          ),
          Column(
            children: [
              SizedBox(
                width: size.width,
                height: 230.0 * recruitements.length,
                child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ItemRecuitment(
                        recruitment: recruitements[index].recruitment,
                        marginHorizontal: 0,
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 20,
                        ),
                    itemCount: recruitements.length),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      numberPaging++;
                      recruitements = await Modular.get<ProviderRecruitment>()
                          .getListRecruitByCompanyPaging(
                              widget.company.id, numberPaging);
                    },
                    child: const Text(
                      'Xem thêm',
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SvgPicture.asset(
                    ImageFactory.chevronDown,
                    width: 22,
                    height: 22,
                    color: primaryColor,
                  )
                ],
              )
            ],
          ),
        ],
      ),
    ));
  }

  Widget buildInfoRecruitment(Size size) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        width: size.width,
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.only(
                  left: 15.w, right: 15.w, top: 10.h, bottom: 20.h),
              margin: const EdgeInsets.only(bottom: 25, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Thông tin chung',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.black.withOpacity(0.7)),
                  ),
                  InfoRecuitmentItem(
                    icon: ImageFactory.piggy,
                    title: 'Mức lương',
                    content: widget.recruitment.salary!,
                  ),
                  InfoRecuitmentItem(
                    icon: ImageFactory.work,
                    title: 'Hình thức làm việc',
                    content: widget.recruitment.workingForm!,
                  ),
                  InfoRecuitmentItem(
                    icon: ImageFactory.threePerson,
                    title: 'Số lượng cần tuyển',
                    content: widget.recruitment.numberOfRecruits.toString(),
                  ),
                  InfoRecuitmentItem(
                    icon: ImageFactory.sex,
                    title: 'Giới tính',
                    content: widget.recruitment.gender!,
                  ),
                  InfoRecuitmentItem(
                    icon: ImageFactory.workExp,
                    title: 'Kinh nghiệm',
                    content: widget.recruitment.experience!,
                  ),
                  InfoRecuitmentItem(
                    icon: ImageFactory.paper,
                    title: 'Chức vụ',
                    content: widget.recruitment.position!,
                  ),
                  InfoRecuitmentItem(
                    icon: ImageFactory.location,
                    title: 'Địa chỉ',
                    content: widget.recruitment.address!,
                  ),
                ],
              ),
            ),
            TagInfoWidget(
                title: 'Mô tả công việc',
                content: widget.recruitment.descriptionWorking!),
            TagInfoWidget(
                title: 'Yêu cầu ứng viên',
                content: widget.recruitment.request!),
            TagInfoWidget(
                title: 'Quyền lợi', content: widget.recruitment.benefit!)
          ],
        ),
      ),
    );
  }
}
