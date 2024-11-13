// ignore_for_file: deprecated_member_use

import 'package:app/configs/image_factory.dart';
import 'package:app/configs/route_path.dart';
import 'package:app/configs/uri.dart';
import 'package:app/modules/candidate/data/models/company_model.dart';
import 'package:app/modules/candidate/presentations/themes/color.dart';
import 'package:app/modules/recruiter/data/provider/recruiter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RecruiterAccountScreen extends StatefulWidget {
  const RecruiterAccountScreen({super.key});

  @override
  State<RecruiterAccountScreen> createState() => _RecruiterAccountScreenState();
}

class _RecruiterAccountScreenState extends State<RecruiterAccountScreen> {
  @override
  void initState() {
    _loadProfile();
    super.initState();
  }

  _loadProfile() async {}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final company =
        context.watch<RecruiterProvider>((p) => p.recruiter).recruiter;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: const BackButton(),
      body: SingleChildScrollView(
        child: Column(children: [
          _top(size, company),
          _body(company),
          _bottom(),
        ]),
      ),
    );
  }

  Widget _top(Size size, Company company) => SizedBox(
        width: size.width,
        height: 200 + kToolbarHeight,
        child: Stack(
          children: [
            Positioned(
                top: 0,
                child: Container(
                  height: 120 + kToolbarHeight,
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
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
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
                          onTap: () {},
                          child: Stack(
                            children: [
                              Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                        width: 2, color: primaryColor),
                                    image: DecorationImage(
                                        image: NetworkImage(getAvatarCompany(
                                            company.avatar.toString())),
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
                                    child: SvgPicture.asset(ImageFactory.camera,
                                        height: 20, width: 20),
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
                              company.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                            ),
                            Text(
                              'Info : ${company.info}',
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      );

  Widget _body(Company company) => Stack(
        children: [
          Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: Column(children: [
                GestureDetector(
                  onTap: () {},
                  child: ItemInfo(
                      icon: ImageFactory.person,
                      title: 'Tên công ty',
                      content: company.name),
                ),
                GestureDetector(
                  onTap: () {},
                  child: ItemInfo(
                      icon: ImageFactory.call,
                      title: 'Liên hệ',
                      content: company.contact),
                ),
                GestureDetector(
                  onTap: () {},
                  child: ItemInfo(
                      icon: ImageFactory.company,
                      title: 'Địa chỉ',
                      content: company.address ?? ''),
                ),
                GestureDetector(
                  onTap: () {},
                  child: ItemInfo(
                      icon: ImageFactory.information,
                      title: 'Giới thiệu',
                      content: company.intro ?? ''),
                ),
              ])),
          Positioned(
            right: 8,
            top: 0,
            child: GestureDetector(
              onTap: () => Modular.to.pushNamed(RoutePath.updateAccount),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(14)),
                child: const Icon(Icons.edit, size: 20),
              ),
            ),
          )
        ],
      );

  Widget _bottom() => Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: Column(children: [
        GestureDetector(
          onTap: () {
            Modular.to.navigate(RoutePath.login);
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 216, 241, 220)),
                height: 35.h,
                width: 35.h,
                child: SvgPicture.asset(
                  ImageFactory.logout,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 26),
              const Expanded(
                child: Text(
                  'Đăng xuất',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              SvgPicture.asset(
                ImageFactory.right,
                width: 20,
                height: 20,
                color: Colors.grey,
              )
            ],
          ),
        )
      ]));
}

class ItemInfo extends StatelessWidget {
  const ItemInfo(
      {super.key,
      required this.icon,
      required this.title,
      required this.content});

  final String icon;
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 10.h, bottom: 10),
      width: size.width - 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 216, 241, 220)),
            height: 35.h,
            width: 35.h,
            child: SvgPicture.asset(
              icon,
              color: primaryColor,
            ),
          ),
          const SizedBox(
            width: 16.0,
          ),
          SizedBox(
            width: size.width - 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 25,
                  child: Text(
                    title,
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  width: size.width - 115,
                  child: Text(
                    content,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
