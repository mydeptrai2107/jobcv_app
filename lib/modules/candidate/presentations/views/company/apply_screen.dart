// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:convert';

import 'package:app/configs/image_factory.dart';
import 'package:app/configs/route_path.dart';
import 'package:app/configs/text_app.dart';
import 'package:app/modules/candidate/data/models/profile_model.dart';
import 'package:app/modules/candidate/data/models/user_model.dart';
import 'package:app/modules/candidate/domain/providers/provider_auth.dart';
import 'package:app/modules/candidate/domain/providers/provider_profile.dart';
import 'package:app/modules/candidate/presentations/themes/color.dart';
import 'package:app/modules/candidate/presentations/views/widgets/button_app.dart';
import 'package:app/shared/models/recruitment_model.dart';
import 'package:app/shared/provider/provider_apply.dart';
import 'package:app/shared/utils/notiface_message.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ApplyScreen extends StatefulWidget {
  const ApplyScreen(
      {super.key, required this.recruitment, required this.idComapny});

  final Recruitment recruitment;
  final String idComapny;

  @override
  State<ApplyScreen> createState() => _ApplyScreenState();
}

class _ApplyScreenState extends State<ApplyScreen> {
  TextEditingController introController = TextEditingController();
  FilePickerResult? fileResult;
  PlatformFile? plagformFile;

  List<Profile> listProfile = [];
  String isChooseCV = 'jobcv';
  String chooseCV = '';
  late Profile chooseProfile;

  initData() async {
    listProfile = await Modular.get<ProviderProfile>().getListProfile();
    chooseProfile = listProfile[0];
    chooseCV = chooseProfile.name;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    context.watch<ProviderProfile>();
    final providerApply = context.watch<ProviderApply>();
    context.watch<ProviderAuth>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ứng tuyển'),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        color: Colors.grey[200],
        padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
        child: Container(
          padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
          color: Colors.white,
          height: size.height,
          width: size.width - 30,
          child: ListView(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.all(15),
                width: size.width - 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(
                        width: isChooseCV == 'jobcv' ? 0.5 : 0.2,
                        color: Colors.grey)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Chọn CV online',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: isChooseCV == 'jobcv'
                                  ? Colors.black
                                  : Colors.grey),
                        ),
                        Expanded(child: Container()),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                              color: isChooseCV == 'jobcv'
                                  ? primaryColor.withOpacity(0.2)
                                  : primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            'Khuyên dùng',
                            style: TextStyle(
                                fontSize: 14,
                                color: isChooseCV == 'jobcv'
                                    ? primaryColor
                                    : primaryColor.withOpacity(0.2),
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Radio(
                          activeColor: primaryColor,
                          value: 'jobcv',
                          groupValue: isChooseCV,
                          onChanged: (value) {
                            setState(() {
                              isChooseCV = value!;
                            });
                          },
                        )
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        if (isChooseCV == 'jobcv') {
                          showModalBottom(context, listProfile);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        width: size.width - 45,
                        height: 50,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: isChooseCV == 'jobcv' ? 1 : 0.3,
                                color: Colors.grey)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: size.width - 150,
                              child: Text(
                                chooseCV,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: isChooseCV == 'jobcv'
                                        ? Colors.black
                                        : Colors.grey,
                                    fontSize: 18),
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down_rounded)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),

              GestureDetector(
                onTap: () async {},
                child: Container(
                  margin: const EdgeInsets.only(bottom: 25),
                  padding: const EdgeInsets.all(15),
                  height: 120,
                  width: size.width - 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(
                          width: isChooseCV == 'jobcv' ? 0.2 : 0.5,
                          color: Colors.grey)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Tải lên từ điện thoại',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: isChooseCV == 'jobcv'
                                    ? Colors.grey
                                    : Colors.black),
                          ),
                          Expanded(child: Container()),
                          Radio(
                            activeColor: primaryColor,
                            value: 'android',
                            groupValue: isChooseCV,
                            onChanged: (value) {
                              setState(() {
                                isChooseCV = value!;
                              });
                            },
                          )
                        ],
                      ),
                      ButtonApp(
                        textColor:
                            isChooseCV == 'jobcv' ? Colors.grey : Colors.white,
                        backGroundColor: isChooseCV == 'jobcv'
                            ? Colors.grey.withOpacity(0.1)
                            : primaryColor,
                        title: 'Tải lên',
                        onPress: () async {
                          fileResult = await FilePicker.platform.pickFiles();
                          if (fileResult == null) return;
                          plagformFile = fileResult!.files.first;
                          setState(() {});
                        },
                        borderRadius: 5,
                      )
                    ],
                  ),
                ),
              ),

              if (plagformFile != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: size.width - 130,
                        child: Text(
                          plagformFile!.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            plagformFile = null;
                          });
                        },
                        child: SvgPicture.asset(
                          ImageFactory.delete,
                          width: 20,
                          height: 20,
                          color: Colors.red,
                        ),
                      )
                    ],
                  ),
                ),

              //
              const Text(
                'Thư giới thiệu',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                margin: const EdgeInsets.only(top: 10, bottom: 25),
                height: 150,
                width: size.width - 30,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(7)),
                child: TextField(
                  controller: introController,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: TextApp.introMyself,
                      hintStyle:
                          TextStyle(color: Colors.grey[400], fontSize: 14)),
                  maxLines: 10,
                ),
              ),

              Row(
                children: [
                  SvgPicture.asset(
                    ImageFactory.warning,
                    width: 20,
                    height: 20,
                    color: Colors.red,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  const Text(
                    'Lưu ý',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                ],
              ),

              const SizedBox(
                height: 15,
              ),

              const Text(
                TextApp.warningApply1,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              ),

              const SizedBox(
                height: 10,
              ),

              const Text(
                TextApp.warningApply2,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              ),

              const SizedBox(
                height: 10,
              ),

              const Text(
                TextApp.warningApply3,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              ),

              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 7),
          height: 50.h,
          width: size.width,
          color: Colors.white,
          child: providerApply.isLoading
              ? Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 70, vertical: 4),
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: const CircularProgressIndicator(),
                  ),
                )
              : Expanded(
                  child: ButtonApp(
                  height: 38,
                  onPress: () async {
                    try {
                      UserModel user = Modular.get<ProviderAuth>().user;

                      await providerApply.createApply(
                          user.userId,
                          chooseProfile.id,
                          widget.recruitment.id!,
                          widget.recruitment.title!,
                          widget.idComapny,
                          introController.text);
                      OverlayEntry? overlayEntry;
                      overlayEntry = OverlayEntry(
                        builder: (BuildContext context) {
                          return ShowApplySuccess(
                            entry: overlayEntry,
                          );
                        },
                      );

                      Overlay.of(context).insert(overlayEntry);
                    } catch (e) {
                      notifaceError(
                          context, jsonDecode(e.toString())['message']);
                    }
                  },
                  title: 'Ứng tuyển',
                  borderRadius: 100,
                ))),
    );
  }

  void showModalBottom(BuildContext context, List<Profile> list) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.separated(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(listProfile[index].name),
              onTap: () {
                chooseProfile = list[index];
                chooseCV = chooseProfile.name;
                setState(() {
                  Navigator.pop(context);
                });
              },
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(
              thickness: 1,
            );
          },
        );
      },
    );
  }
}

// ignore: must_be_immutable
class ShowApplySuccess extends StatelessWidget {
  ShowApplySuccess({
    super.key,
    required this.entry,
  });
  OverlayEntry? entry;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              entry!.remove();
            },
            child: Container(
              color: const Color.fromARGB(83, 73, 59, 59),
            ),
          ),
        ),
        Positioned(
          top: 30,
          left: 25,
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              //height: size.height - 200,
              width: size.width - 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    ImageFactory.success,
                    width: 70,
                    height: 70,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Ứng tuyển việt làm thành công',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: primaryColor),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    TextApp.applySuccess,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ButtonApp(
                    title: 'Xem danh sách việc làm đã ứng tuyển',
                    borderRadius: 6,
                    onPress: () {
                      entry!.remove();
                      Modular.to.pushNamed(RoutePath.appliedScreen);
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    height: 10,
                    child: const Divider(
                      thickness: 1,
                    ),
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        ImageFactory.warning,
                        width: 20,
                        height: 20,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      const Text(
                        'Lưu ý',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    TextApp.warningApply1,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  const Text(
                    TextApp.warningApply2,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  const Text(
                    TextApp.warningApply3,
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
