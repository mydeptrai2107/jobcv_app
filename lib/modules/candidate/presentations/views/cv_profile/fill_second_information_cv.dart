// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:app/configs/route_path.dart';
import 'package:app/configs/uri.dart';
import 'package:app/modules/candidate/data/models/province.dart';
import 'package:app/modules/candidate/data/repositories/repository_map_vn.dart';
import 'package:app/modules/candidate/domain/providers/provider_app.dart';
import 'package:app/modules/candidate/domain/providers/provider_auth.dart';
import 'package:app/modules/candidate/domain/providers/provider_user.dart';
import 'package:app/modules/candidate/domain/use_case/get_province.dart';
import 'package:app/modules/candidate/presentations/themes/color.dart';
import 'package:app/modules/candidate/presentations/views/cv_profile/widgets/experience_item.dart';
import 'package:app/modules/candidate/presentations/views/cv_profile/widgets/school_item.dart';
import 'package:app/modules/candidate/presentations/views/cv_profile/widgets/skill_item.dart';
import 'package:app/modules/candidate/presentations/views/widgets/button_app.dart';
import 'package:app/modules/candidate/presentations/views/widgets/button_outline.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/foundation.dart';
import 'package:pdf/widgets.dart' as pw;

class FillSecondInformationScreen extends StatefulWidget {
  const FillSecondInformationScreen(
      {super.key, required this.id, required this.name, required this.idUser});

  final String id;
  final String name;
  final String idUser;

  @override
  State<FillSecondInformationScreen> createState() =>
      _FillSecondInformationScreenState();
}

class _FillSecondInformationScreenState
    extends State<FillSecondInformationScreen> {
  List<String> gender = ['Nam', 'Nữ'];
  String selectGender = 'Nam';
  String avatar = '';
  GetProvince getProvince = GetProvince(reporitpryMap: ReporitoryMap());
  List<Province> listProvince = [];
  final TextEditingController _provinceController = TextEditingController();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _gitController = TextEditingController();
  final TextEditingController _infoController = TextEditingController();

  final _box = Hive.box('info');

  File? imageFile;
  final picker = ImagePicker();
  Uint8List? bytes;
  final pdf = pw.Document();

  @override
  void initState() {
    super.initState();
    getData();
    _nameController.text = _box.get('name') ?? '';
    _positionController.text = _box.get('position') ?? '';
    _emailController.text = _box.get('email') ?? '';
    _phoneNumberController.text = _box.get('phoneNumber') ?? '';
    _addressController.text = _box.get('address') ?? '';
    _linkController.text = _box.get('link') ?? '';
    _gitController.text = _box.get('git') ?? '';
    _infoController.text = _box.get('info') ?? '';
    _provinceController.text = _box.get('province') ?? '';
  }

  getData() async {
    listProvince = await getProvince.get();
    avatar = Modular.get<ProviderAuth>().user.avatar.toString();
    setState(() {});
  }

  @override
  void dispose() {
    _nameController.dispose();
    _positionController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _linkController.dispose();
    _gitController.dispose();
    _infoController.dispose();
    super.dispose();
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
        aspectRatio: const CropAspectRatio(ratioX: 3/2, ratioY: 3/2),
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
      setState(() {
        imageFile = File(croppedFile.path);
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
                      child:const Column(
                        children:  [
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
                      child:const SizedBox(
                        child: Column(
                          children:  [
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final providerApp = context.watch<ProviderApp>();
    final providerUser = context.watch<ProviderUser>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Thông tin chung'),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        height: size.height,
        width: size.width,
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thông tin cá nhân',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  GestureDetector(
                    onDoubleTap: () async {
                      Map<Permission, PermissionStatus> statuses = await [
                        Permission.storage,
                        Permission.camera
                      ].request();

                      if (statuses[Permission.storage]!.isGranted &&
                          statuses[Permission.camera]!.isGranted) {
                        showImagePicker(context);
                      }
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        imageFile == null
                            ? Container(
                                margin: EdgeInsets.only(
                                    right: 20.w, bottom: 15.h, top: 15.h),
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image:
                                          NetworkImage(getAvatarUser(avatar)),
                                      fit: BoxFit.fill),
                                  shape: BoxShape.circle,
                                ))
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(150),
                                child: Image.file(
                                  imageFile!,
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.fill,
                                ),
                              ),
                        const Text(
                          'Chạm 2 lần để chỉnh sửa ảnh',
                          style: TextStyle(fontSize: 14),
                        )
                      ],
                    ),
                  ),

                  const Divider(
                    thickness: 1,
                  ),

                  //full name
                  const Text(
                    'Họ và tên',
                    style: TextStyle(fontSize: 14),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    margin: const EdgeInsets.only(top: 5, bottom: 15),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: _nameController.text.isEmpty
                                ? Colors.red
                                : Colors.grey,
                            width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      controller: _nameController,
                      cursorColor: _nameController.text.isEmpty
                          ? Colors.red
                          : Colors.grey,
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  //position to apply
                  const Text(
                    'Vị trí làm việc mong muốn',
                    style: TextStyle(fontSize: 14),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    margin: const EdgeInsets.only(top: 5, bottom: 15),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: _nameController.text.isEmpty
                                ? Colors.red
                                : Colors.grey,
                            width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      controller: _positionController,
                      cursorColor: _positionController.text.isEmpty
                          ? Colors.red
                          : Colors.grey,
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  //email
                  const Text(
                    'email',
                    style: TextStyle(fontSize: 14),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    margin: const EdgeInsets.only(top: 5, bottom: 15),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: _emailController.text.isEmpty
                                ? Colors.red
                                : Colors.grey,
                            width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      controller: _emailController,
                      cursorColor: _nameController.text.isEmpty
                          ? Colors.red
                          : Colors.grey,
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  //Phone
                  const Text(
                    'Số điện thoại',
                    style: TextStyle(fontSize: 14),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    margin: const EdgeInsets.only(top: 5, bottom: 15),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: _phoneNumberController.text.isEmpty
                                ? Colors.red
                                : Colors.grey,
                            width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _phoneNumberController,
                      cursorColor: _phoneNumberController.text.isEmpty
                          ? Colors.red
                          : Colors.grey,
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  //gender
                  const Text(
                    'Giới tính',
                    style: TextStyle(fontSize: 14),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    margin: const EdgeInsets.only(top: 5, bottom: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 1, color: Colors.grey)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                          isExpanded: true,
                          value: selectGender,
                          items: gender
                              .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    e,
                                    style: const TextStyle(fontSize: 14),
                                  )))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectGender = value!.toString();
                            });
                          }),
                    ),
                  ),

                  //select province
                  const Text(
                    'Tỉnh',
                    style: TextStyle(fontSize: 14),
                  ),
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        margin: const EdgeInsets.only(top: 5, bottom: 15),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: _provinceController.text.isEmpty
                                    ? Colors.red
                                    : Colors.grey,
                                width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        child: TextFormField(
                          controller: _provinceController,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w400)),
                        ),
                      ),
                      Opacity(
                        opacity: 0,
                        child: SizedBox(
                          height: 60,
                          width: size.width,
                          child: DropdownButton(
                            isExpanded: true,
                            items: listProvince
                                .map<DropdownMenuItem>((e) => DropdownMenuItem(
                                      value: e.name,
                                      child: Text(
                                        e.name,
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) async {
                              setState(() {
                                _provinceController.text = value;
                                _box.put('province', value);
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  //address
                  const Text(
                    'Địa chỉ',
                    style: TextStyle(fontSize: 14),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    margin: const EdgeInsets.only(top: 5, bottom: 15),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      controller: _addressController,
                      cursorColor: Colors.red,
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  //Liên kết
                  const Text(
                    'Liên kết',
                    style: TextStyle(fontSize: 14),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    margin: const EdgeInsets.only(top: 5, bottom: 15),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      controller: _linkController,
                      cursorColor: Colors.red,
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  //Github
                  const Text(
                    'Github',
                    style: TextStyle(fontSize: 14),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    margin: const EdgeInsets.only(top: 5, bottom: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      controller: _gitController,
                      cursorColor: Colors.red,
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //introduction
            Container(
              height: 20.h,
              color: const Color.fromARGB(255, 211, 208, 208),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              margin: const EdgeInsets.only(top: 15, bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thông tin cá nhân',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    margin: const EdgeInsets.only(top: 15),
                    height: 200,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      controller: _infoController,
                      maxLines: 10,
                      cursorColor: Colors.red,
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: 'nhập để thêm phần giới thiệu',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //working Experience
            Container(
              height: 20.h,
              color: const Color.fromARGB(255, 211, 208, 208),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              margin: const EdgeInsets.only(top: 15, bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kinh nghiệm làm việc',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  for (int i = 0; i < providerApp.listExperience.length; i++)
                    ExperienceItem(experience: providerApp.listExperience[i]),
                  GestureDetector(
                    onTap: () {
                      Modular.to.pushNamed(RoutePath.addWorkingExperience);
                    },
                    child: Container(
                        width: size.width,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        margin: const EdgeInsets.only(top: 15, bottom: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Center(
                          child: Text(
                            'Add New ✚',
                            style: TextStyle(color: primaryColor),
                          ),
                        )),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    margin: const EdgeInsets.only(top: 15),
                    height: 150,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextFormField(
                      maxLines: 10,
                      cursorColor: Colors.red,
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: 'Kinh nghiệm khác',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //skill
            Container(
              height: 20.h,
              color: const Color.fromARGB(255, 211, 208, 208),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              margin: const EdgeInsets.only(top: 15, bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kỹ năng',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  for (int i = 0; i < providerApp.listSkill.length; i++)
                    SkillItem(skillModel: providerApp.listSkill[i]),
                  GestureDetector(
                    onTap: () {
                      Modular.to.pushNamed(RoutePath.addSkill);
                    },
                    child: Container(
                        width: size.width,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        margin: const EdgeInsets.only(top: 15, bottom: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Center(
                          child: Text(
                            'Add New ✚',
                            style: TextStyle(color: primaryColor),
                          ),
                        )),
                  ),
                ],
              ),
            ),

            //education
            Container(
              height: 20.h,
              color: const Color.fromARGB(255, 211, 208, 208),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              margin: const EdgeInsets.only(top: 15, bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Giáo dục',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  for (int i = 0; i < providerApp.listSchool.length; i++)
                    SchoolItem(schoolModel: providerApp.listSchool[i]),
                  GestureDetector(
                    onTap: () {
                      Modular.to.pushNamed(RoutePath.addEducation);
                    },
                    child: Container(
                        width: size.width,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        margin: const EdgeInsets.only(top: 15, bottom: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Center(
                          child: Text(
                            'Add New ✚',
                            style: TextStyle(color: primaryColor),
                          ),
                        )),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    color: Colors.black.withOpacity(0.6), width: 1))),
        height: 65,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: ButtonApp(
                  borderRadius: 100,
                  onPress: () async {
                    await saveCV();
                    providerUser.updateAvatar(
                        id: widget.idUser, avatar: imageFile);
                    ElegantNotification.success(
                      width: 360,
                      animation: AnimationType.fromTop,
                      title: const Text('Lưu thông tin'),
                      description:
                          const Text('Thông tin của bạn đã lưu thành công'),
                      onDismiss: () {},
                    ).show(context);
                  },
                  title: 'Lưu CV',
                  paddingvertical: 15,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: ButtonOutline(
                  borderRadius: 100,
                  onPress: () {},
                  title: 'Xem trước',
                  paddingvertical: 15,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  saveCV() async {
    if (_nameController.text.trim() != '') {
      await _box.put('name', _nameController.text);
    }
    if (_positionController.text.trim() != '') {
      await _box.put('position', _positionController.text);
    }
    if (_emailController.text.trim() != '') {
      await _box.put('email', _emailController.text);
    }
    if (_phoneNumberController.text.trim() != '') {
      await _box.put('phoneNumber', _phoneNumberController.text);
    }
    if (_addressController.text.trim() != '') {
      await _box.put('address', _addressController.text);
    }
    if (_linkController.text.trim() != '') {
      await _box.put('link', _linkController.text);
    }
    if (_gitController.text.trim() != '') {
      await _box.put('git', _gitController.text);
    }
    if (_infoController.text.trim() != '') {
      await _box.put('info', _infoController.text);
    }
  }
}
