import 'package:app/configs/image_factory.dart';
import 'package:app/configs/route_path.dart';
import 'package:app/configs/text_app.dart';
import 'package:app/modules/candidate/data/models/hive_models/experience_model.dart';
import 'package:app/modules/candidate/data/models/hive_models/school_model.dart';
import 'package:app/modules/candidate/presentations/views/cv_profile/widgets/information_item.dart';
import 'package:app/modules/candidate/presentations/views/widgets/button_app.dart';
import 'package:app/modules/candidate/presentations/views/widgets/button_outline.dart';
import 'package:app/shared/utils/notiface_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CreateCVScreen extends StatefulWidget {
  const CreateCVScreen(
      {super.key,
      required this.id,
      required this.name,
      required this.idUser,
      required this.language});

  final String id;
  final String name;
  final String idUser;
  final String language;

  @override
  State<CreateCVScreen> createState() => _CreateCVScreenState();
}

class _CreateCVScreenState extends State<CreateCVScreen> {
  final _box = Hive.box('info');
  final _experience = Hive.box<ExperienceModel>('Experience');
  final _school = Hive.box<SchoolModel>('school');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Tạo CV'),
          centerTitle: true,
        ),
        body: Container(
          color: Colors.white,
          height: size.height,
          width: size.width,
          child: ListView(
            children: [
              //Note
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15.w),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hướng dẫn',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(TextApp.guideline1),
                    SizedBox(
                      height: 7,
                    ),
                    Text(TextApp.guideline2),
                    SizedBox(
                      height: 7,
                    ),
                    Text(TextApp.guideline3),
                    SizedBox(
                      height: 7,
                    ),
                    Text(TextApp.guideline4),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),

              Container(
                height: 20.h,
                color: const Color.fromARGB(255, 241, 240, 240),
              ),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Thông tin bản thân',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    InformationItem(
                      icon: ImageFactory.person,
                      title: 'Thông tin cá nhân',
                      onPress: () {
                        Modular.to.pushNamed(RoutePath.fillSecondInfoCV,
                            arguments: [
                              widget.id,
                              widget.name,
                              widget.idUser,
                              widget.language
                            ]);
                      },
                    ),
                    InformationItem(
                      icon: ImageFactory.documentText,
                      title: 'giới thiệu tóm tắt',
                    ),
                    InformationItem(
                      icon: ImageFactory.start,
                      title: 'Kinh nghiệm làm việc',
                    ),
                    InformationItem(
                      icon: ImageFactory.barChart,
                      title: 'Kỹ năng',
                    ),
                    InformationItem(
                      icon: ImageFactory.school,
                      title: 'Học vấn',
                    )
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
                  child: ButtonOutline(
                    borderRadius: 100,
                    onPress: () {
                      Modular.to.navigate(RoutePath.listProfile);
                    },
                    title: 'Quay lại',
                    paddingvertical: 15,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: ButtonApp(
                    borderRadius: 100,
                    onPress: () async {
                      if (_box.get('name').toString().trim() == '' ||
                          _box.get('name') == null ||
                          _box.get('position').toString().trim() == '' ||
                          _box.get('position') == null ||
                          _box.get('email').toString().trim() == '' ||
                          _box.get('email') == null ||
                          _box.get('phoneNumber').toString().trim() == '' ||
                          _box.get('phoneNumber') == null ||
                          _box.get('link').toString().trim() == '' ||
                          _box.get('link') == null ||
                          _box.get('address').toString().trim() == '' ||
                          _box.get('address') == null ||
                          _box.get('info').toString().trim() == '' ||
                          _box.get('info') == null) {
                        notifaceError(
                            context, 'Vui lòng điền đầy đủ thông tin.');
                        return;
                      }
                      Modular.to.pushNamed(RoutePath.previewCV, arguments: [
                        _box.get('name') ?? '',
                        _box.get('position') ?? '',
                        DateTime.now(),
                        _box.get('email') ?? '',
                        _box.get('phoneNumber') ?? '',
                        _box.get('link') ?? '',
                        _box.get('git') ?? '',
                        _box.get('address') ?? '',
                        _box.get('info') ?? '',
                        _experience.values.toList(),
                        _school.values.toList(),
                        widget.id,
                        widget.name,
                        widget.language
                      ]);
                    },
                    title: 'Xem CV',
                    paddingvertical: 15,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
