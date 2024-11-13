// ignore_for_file: deprecated_member_use

import 'package:app/configs/font_style_text.dart';
import 'package:app/configs/image_factory.dart';
import 'package:app/configs/route_path.dart';
import 'package:app/configs/text_app.dart';
import 'package:app/modules/candidate/data/models/profile_model.dart';
import 'package:app/modules/candidate/data/models/user_model.dart';
import 'package:app/modules/candidate/domain/providers/provider_auth.dart';
import 'package:app/modules/candidate/domain/providers/provider_profile.dart';
import 'package:app/modules/candidate/presentations/themes/color.dart';
import 'package:app/modules/candidate/presentations/views/widgets/button_app.dart';
import 'package:app/shared/utils/notiface_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class FillFirstInformationCV extends StatefulWidget {
  const FillFirstInformationCV({super.key});

  @override
  State<FillFirstInformationCV> createState() => _FillFirstInformationCVState();
}

class _FillFirstInformationCVState extends State<FillFirstInformationCV> {
  var languages = ['Tiếng Việt', 'Tiếng Anh'];
  String selectLanguge = 'Tiếng Việt';

  TextEditingController nameCvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final providerProfile = context.watch<ProviderProfile>();
    context.watch<ProviderAuth>();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 229, 229),
      appBar: AppBar(
        title: const Text(
          'Tạo CV',
          style: textStyleTitleAppBar,
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(15),
        color: Colors.white,
        width: size.width,
        height: size.height,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  ImageFactory.colorWand,
                  color: primaryColor,
                  width: 25,
                  height: 25,
                ),
                SizedBox(
                  width: 5.w,
                ),
                const Text(
                  TextApp.fillInfor,
                  style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 14),
                )
              ],
            ),

            const Divider(
              thickness: 1,
            ),

            SizedBox(
              height: 10.h,
            ),
            //language
            const Text(
              'Tên CV',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 1, color: Colors.grey),
              ),
              child: TextField(
                controller: nameCvController,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),

            SizedBox(
              height: 20.h,
            ),

            //language
            const Text(
              'Ngôn ngữ CV',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(width: 1, color: Colors.grey)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                    isExpanded: true,
                    value: selectLanguge,
                    items: languages
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectLanguge = value!.toString();
                      });
                    }),
              ),
            ),

            SizedBox(
              height: 20.h,
            ),
            providerProfile.isLoadignCreate
                ? Center(
                    child: ButtonApp(
                      paddingHorizontal: 50,
                      title: 'Bắt đầu',
                      onPress: () async {
                        if (nameCvController.text.trim() == '') {
                          notifaceError(context, 'Tên CV không được để trống.');
                        } else {
                          UserModel user = Modular.get<ProviderAuth>().user;
                          Profile profile = await providerProfile.createProfile(
                              nameCvController.text, user.userId);
                          Modular.to.navigate(RoutePath.createCV, arguments: [
                            profile.id,
                            profile.name,
                            user.userId,
                            selectLanguge
                          ]);
                        }
                      },
                    ),
                  )
                : const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
