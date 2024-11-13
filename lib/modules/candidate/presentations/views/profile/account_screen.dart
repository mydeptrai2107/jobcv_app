// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:app/configs/image_factory.dart';
import 'package:app/configs/route_path.dart';
import 'package:app/configs/text_app.dart';
import 'package:app/configs/uri.dart';
import 'package:app/modules/candidate/data/models/hive_models/experience_model.dart';
import 'package:app/modules/candidate/data/models/hive_models/school_model.dart';
import 'package:app/modules/candidate/data/models/hive_models/skill_model.dart';
import 'package:app/modules/candidate/data/models/profile_model.dart';
import 'package:app/modules/candidate/data/models/user_model.dart';
import 'package:app/modules/candidate/domain/providers/provider_app.dart';
import 'package:app/shared/provider/provider_apply.dart';
import 'package:app/modules/candidate/domain/providers/provider_auth.dart';
import 'package:app/shared/provider/provider_company.dart';
import 'package:app/modules/candidate/domain/providers/provider_profile.dart';
import 'package:app/shared/provider/provider_recruitment.dart';
import 'package:app/modules/candidate/domain/providers/provider_user.dart';
import 'package:app/modules/candidate/presentations/themes/color.dart';
import 'package:app/modules/candidate/presentations/views/profile/widgets/item_manage_job.dart';
import 'package:app/modules/candidate/presentations/views/profile/widgets/item_profile.dart';
import 'package:app/modules/candidate/presentations/views/widgets/button_app.dart';
import 'package:app/modules/candidate/presentations/views/widgets/button_outline.dart';
import 'package:app/shared/utils/format.dart';
import 'package:app/shared/utils/notiface_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  File? imageFile;
  final picker = ImagePicker();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  final _schoolBox = Hive.box<SchoolModel>('School');
  final _experienceBox = Hive.box<ExperienceModel>('Experience');
  final _skillBox = Hive.box<SkillModel>('skill');
  String nameUser = '';
  String phoneNumber = '';
  bool male = true;
  int countProfile = 0;
  int countApplied = 0;
  int countSavedRecruitment = 0;
  int countCompany = 0;

  List<Profile> listProvider = [];
  final _box = Hive.box('info');

  UserModel user = Modular.get<ProviderAuth>().user;

  void initData() async {
    listProvider = await Modular.get<ProviderProfile>().getListProfile();
    nameUser = '${user.firstName} ${user.lastName}';
    phoneNumber = user.phone.toString();
    male = user.gender.toString().toLowerCase() == 'male';
    countProfile = await Modular.get<ProviderProfile>().getcountProfile();
    countApplied = await Modular.get<ProviderApply>().getCountApply();
    countSavedRecruitment = await Modular.get<ProviderRecruitment>()
        .getCountRecruitmentSaved(user.userId);
    countCompany =
        await Modular.get<ProviderCompany>().getCountCompanySaved(user.userId);
  }

  @override
  void initState() {
    super.initState();
    initData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    context.watch<ProviderUser>();
    context.watch<ProviderProfile>();
    final providerApp = context.watch<ProviderApp>();
    context.watch<ProviderApply>();
    context.watch<ProviderAuth>();
    context.watch<ProviderCompany>();
    context.watch<ProviderRecruitment>();
    final providerRecruitment = context.watch<ProviderRecruitment>();

    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: ListView(
          children: [
            SizedBox(
              width: size.width,
              height: 200,
              child: Stack(
                children: [
                  Positioned(
                      top: 0,
                      child: Container(
                        height: 120,
                        width: size.width,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              primaryColor,
                              primaryColor.withOpacity(0.1),
                            ],
                          ),
                        ),
                      )),
                  Positioned(
                      top: 60,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        padding: const EdgeInsets.all(15),
                        height: 120,
                        width: size.width - 30,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showImagePicker(context);
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(
                                            width: 2, color: primaryColor),
                                        image: imageFile != null
                                            ? DecorationImage(
                                                image: FileImage(imageFile!),
                                                fit: BoxFit.fill)
                                            : DecorationImage(
                                                image: NetworkImage(
                                                    getAvatarUser(user.avatar
                                                        .toString())),
                                                fit: BoxFit.fill)),
                                  ),
                                  Positioned(
                                      top: 50,
                                      left: 50,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                width: 1, color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: SvgPicture.asset(
                                            ImageFactory.camera,
                                            height: 20,
                                            width: 20),
                                      ))
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  nameUser,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'Mã ứng viên: ',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      user.userId.substring(0, 7),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      editName(context, '${user.firstName} ${user.lastName}',
                          user.userId);
                    },
                    child: ItemProfile(
                        icon: ImageFactory.person,
                        title: 'Họ và Tên',
                        content: nameUser),
                  ),
                  GestureDetector(
                    onTap: () {
                      editPhoneNumber(context, phoneNumber, user.userId);
                    },
                    child: ItemProfile(
                        icon: ImageFactory.call,
                        title: 'Số điện thoại',
                        content: phoneNumber),
                  ),
                  GestureDetector(
                    onTap: () {
                      chooseGender(context, user.userId);
                    },
                    child: ItemProfile(
                        icon: ImageFactory.sex,
                        title: 'Giới tính',
                        content: male ? 'nam' : 'nữ'),
                  ),
                  GestureDetector(
                    onTap: () {
                      Modular.to.pushNamed(RoutePath.changePWScreen);
                    },
                    child: const ItemProfile(
                        icon: ImageFactory.keyOutline,
                        title: 'Mật khẩu',
                        content: 'Thay đổi mật khẩu'),
                  ),
                  GestureDetector(
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.remove('accessToken');
                      await prefs.remove('refreshToken');
                      await _box.delete('name');
                      await _box.delete('position');
                      await _box.delete('email');
                      await _box.delete('phoneNumber');
                      await _box.delete('address');
                      await _box.delete('link');
                      await _box.delete('git');
                      await _box.delete('info');
                      await _box.delete('province');
                      for (int i = 0;
                          i < _experienceBox.values.toList().length;
                          i++) {
                        await _experienceBox.deleteAt(i);
                      }
                      for (int j = 0;
                          j < _schoolBox.values.toList().length;
                          j++) {
                        await _schoolBox.deleteAt(j);
                      }
                      for (int z = 0;
                          z < _skillBox.values.toList().length;
                          z++) {
                        await _skillBox.deleteAt(z);
                      }
                      providerApp.fetchAllExperience();
                      providerApp.fetchAllSchool();
                      providerApp.fetchAllSkill();
                      Modular.to.navigate(RoutePath.login);
                    },
                    child: const ItemProfile(
                        icon: ImageFactory.logout,
                        title: 'Đăng xuất',
                        content: 'Phiên bản ứng dụng: 0.0.1'),
                  ),
                ],
              ),
            ),
            // const Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            //   child: Text(
            //     'CV của bạn',
            //     style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
            //   ),
            // ),
            // !provider.isLoading
            //     ? const Center(
            //         child: SizedBox(
            //             height: 30,
            //             width: 30,
            //             child: CircularProgressIndicator()))
            //     : Container(
            //         padding: const EdgeInsets.only(left: 15),
            //         height: 165.0 * listProvider.length,
            //         width: size.width,
            //         child: ListView.separated(
            //           physics: const NeverScrollableScrollPhysics(),
            //           itemCount: listProvider.length,
            //           itemBuilder: (context, index) {
            //             return ItemProfileWidget(
            //               name: listProvider[index].name,
            //               id: listProvider[index].id,
            //               pathCV: listProvider[index].pathCv,
            //               reLoadList: () async {
            //                 listProvider = await provider.getListProfile();
            //               },
            //               updateAt: listProvider[index].updatedAt,
            //             );
            //           },
            //           separatorBuilder: (context, index) => const SizedBox(
            //             height: 15,
            //           ),
            //         ),
            //       ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Text(
                'Quản lý tìm việc',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),

            Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                height: 500,
                width: size.width,
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  crossAxisCount: 2,
                  childAspectRatio: 5 / 2.8,
                  children: [
                    ItemManageJob(
                      icon: ImageFactory.works,
                      title: 'Việc làm ứng tuyển',
                      onTap: () {
                        Modular.to.pushNamed(RoutePath.appliedScreen);
                      },
                      count: countApplied,
                    ),
                    ItemManageJob(
                      icon: ImageFactory.bookmarks,
                      title: 'Việc làm đã lưu',
                      onTap: () {
                        Modular.to.pushNamed(RoutePath.recruitmentSavedScreen,
                            arguments: [
                              () async {
                                countSavedRecruitment =
                                    await providerRecruitment
                                        .getCountRecruitmentSaved(user.userId);
                              }
                            ]);
                      },
                      count: countSavedRecruitment,
                    ),
                    ItemManageJob(
                      icon: ImageFactory.cv,
                      title: 'CV của bạn',
                      onTap: () {
                        Modular.to.navigate(RoutePath.listProfile);
                      },
                      count: countProfile,
                    ),
                    ItemManageJob(
                      icon: ImageFactory.company,
                      title: 'Công ty đang theo dõi',
                      count: countCompany,
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  _imgFromCamera() async {
    await picker
        .pickImage(source: ImageSource.camera, imageQuality: 50)
        .then((value) {
      if (value != null) {
        _cropImage(File(value.path));
      }
    });
  }

  _imgFromGallery() async {
    await picker
        .pickImage(source: ImageSource.gallery, imageQuality: 50)
        .then((value) {
      if (value != null) {
        _cropImage(File(value.path));
      }
    });
  }

  _cropImage(File imgFile) async {
    final croppedFile = await ImageCropper().cropImage(
        sourcePath: imgFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 3 / 2, ratioY: 3 / 2),
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: "Image Cropper",
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: "Image Cropper",
          )
        ]);
    if (croppedFile != null) {
      imageCache.clear();
      setState(() async {
        imageFile = File(croppedFile.path);
        await Modular.get<ProviderUser>()
            .updateAvatar(id: user.userId, avatar: imageFile);
        await Modular.get<ProviderAuth>().getUserUpdate();
      });
      // reload();
    }
  }

  void showImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Card(
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 5.2,
                margin: const EdgeInsets.only(top: 8.0),
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: InkWell(
                      child: const Column(
                        children: [
                          Icon(
                            Icons.image,
                            size: 60.0,
                          ),
                          SizedBox(height: 12.0),
                          Text(
                            "Gallery",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          )
                        ],
                      ),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.pop(context);
                      },
                    )),
                    Expanded(
                        child: InkWell(
                      child: const SizedBox(
                        child: Column(
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 60.0,
                            ),
                            SizedBox(height: 12.0),
                            Text(
                              "Camera",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        _imgFromCamera();
                        Navigator.pop(context);
                      },
                    ))
                  ],
                )),
          );
        });
  }

  void editName(BuildContext context, String name, String id) {
    TextEditingController nameController = TextEditingController(text: name);
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Họ tên của bạn',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(TextApp.inputName),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Nhập họ tên của bạn'),
                ),
              ),
              Expanded(child: Container()),
              ButtonApp(
                title: 'Lưu thay đổi',
                onPress: () async {
                  if (nameController.text.trim() == '') {
                    Modular.to.pop();
                    notifaceError(context, 'Họ và tên không được để trống.');
                    return;
                  }
                  try {
                    await Modular.get<ProviderUser>().updateUserAttribute(
                        key: 'first_name',
                        value: Format.getFirstNameByName(nameController.text),
                        id: id);
                    await Modular.get<ProviderUser>().updateUserAttribute(
                        key: 'last_name',
                        value: Format.getLastNameByName(nameController.text),
                        id: id);
                    nameUser = nameController.text;
                    await Modular.get<ProviderAuth>().getUserUpdate();
                    setState(() {});
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.warning),
                          Expanded(
                              child: Text(jsonDecode(e.toString())['message']))
                        ],
                      ),
                    ));
                  }
                  Modular.to.pop();
                },
                borderRadius: 5,
              ),
              const SizedBox(
                height: 10,
              ),
              ButtonOutline(
                title: 'Hủy',
                onPress: () {
                  Modular.to.pop();
                },
                borderRadius: 5,
              )
            ],
          ),
        );
      },
    );
  }

  void editPhoneNumber(BuildContext context, String phone, String id) {
    TextEditingController phoneController = TextEditingController(text: phone);
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Số điện thoại của bạn',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(TextApp.inputName),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  keyboardType: TextInputType.phone,
                  controller: phoneController,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Nhập số điện thoại của bạn'),
                ),
              ),
              Expanded(child: Container()),
              ButtonApp(
                title: 'Lưu thay đổi',
                onPress: () async {
                  if (phoneController.text.trim() == '') {
                    Modular.to.pop();
                    notifaceError(
                        context, 'Số điện thoại không được để trống.');
                    return;
                  }
                  try {
                    await Modular.get<ProviderUser>().updateUserAttribute(
                        key: 'phone',
                        value: Format.getFirstNameByName(phoneController.text),
                        id: id);
                    phoneNumber = phoneController.text;
                    await Modular.get<ProviderAuth>().getUserUpdate();
                    setState(() {});
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.warning),
                          Expanded(
                              child: Text(jsonDecode(e.toString())['message']))
                        ],
                      ),
                    ));
                  }
                  Modular.to.pop();
                },
                borderRadius: 5,
              ),
              const SizedBox(
                height: 10,
              ),
              ButtonOutline(
                title: 'Hủy',
                onPress: () {
                  Modular.to.pop();
                },
                borderRadius: 5,
              )
            ],
          ),
        );
      },
    );
  }

  void chooseGender(BuildContext context, String id) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Giới tính của bạn',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(TextApp.inputName),
              GestureDetector(
                onTap: () async {
                  if (!male) {
                    await Modular.get<ProviderUser>().updateUserAttribute(
                        key: 'gender', value: 'male', id: id);
                    setState(() {
                      male = !male;
                      Modular.to.pop();
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Nam'),
                      if (male)
                        SvgPicture.asset(
                          ImageFactory.checkmark,
                          width: 20,
                          height: 20,
                        )
                    ],
                  ),
                ),
              ),
              const Divider(
                thickness: 1,
              ),
              GestureDetector(
                onTap: () async {
                  if (male) {
                    await Modular.get<ProviderUser>().updateUserAttribute(
                        key: 'gender', value: 'female', id: id);
                    await Modular.get<ProviderAuth>().getUserUpdate();

                    setState(() {
                      male = !male;
                    });
                    Modular.to.pop();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Nữ'),
                      if (!male)
                        SvgPicture.asset(ImageFactory.checkmark,
                            width: 20, height: 20)
                    ],
                  ),
                ),
              ),
              Expanded(child: Container()),
              ButtonOutline(
                title: 'Hủy',
                onPress: () {
                  Modular.to.pop();
                },
                borderRadius: 5,
              )
            ],
          ),
        );
      },
    );
  }
}
