// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:app/configs/image_factory.dart';
import 'package:app/configs/route_path.dart';
import 'package:app/modules/candidate/data/repositories/user_repositories.dart';
import 'package:app/modules/candidate/domain/providers/provider_profile.dart';
import 'package:app/modules/candidate/presentations/themes/color.dart';
import 'package:app/modules/candidate/presentations/views/widgets/button_app.dart';
import 'package:app/modules/candidate/presentations/views/widgets/button_outline.dart';
import 'package:app/shared/utils/format.dart';
import 'package:app/shared/utils/notiface_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ItemProfileWidget extends StatefulWidget {
  const ItemProfileWidget(
      {super.key,
      required this.name,
      required this.id,
      this.pathCV,
      required this.reLoadList,
      required this.updateAt});

  final String name;
  final String id;
  final String? pathCV;
  final VoidCallback reLoadList;
  final DateTime updateAt;

  @override
  State<ItemProfileWidget> createState() => _ItemProfileWidgetState();
}

class _ItemProfileWidgetState extends State<ItemProfileWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    context.watch<ProviderProfile>();
    UserRepositories userRepositories = UserRepositories();
    return Row(
      children: [
        Container(
          width: size.width - 30,
          height: 450,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  if (widget.pathCV != null) {
                    Modular.to.pushNamed(RoutePath.pdfViewer,
                        arguments: [widget.name, widget.pathCV,false,'']);
                  }
                },
                child: SizedBox(
                  height: 300,
                  width: size.width,
                  child: SfPdfViewer.network(
                    userRepositories.getAvatar(widget.pathCV!),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ],
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    ImageFactory.time,
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    Format.formatDateTimeToYYYYmmHHmm(widget.updateAt),
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    ImageFactory.information,
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'Create on JobCV  ',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (widget.pathCV != null) {
                        Modular.to.pushNamed(RoutePath.pdfViewer,
                            arguments: [widget.name, widget.pathCV,false,'']);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey[200]),
                      child: SvgPicture.asset(
                        ImageFactory.edit,
                        height: 14,
                        width: 14,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 7),
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey[200]),
                    child: SvgPicture.asset(
                      ImageFactory.download,
                      height: 14,
                      width: 14,
                    ),
                  ),
                  Expanded(child: Container()),
                  GestureDetector(
                    onTap: () {
                      moreAction(
                          context, widget.name, widget.id, widget.reLoadList);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey[200]),
                      child: SvgPicture.asset(
                        ImageFactory.more,
                        height: 5,
                        width: 10,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

void moreAction(
    BuildContext context, String name, String id, VoidCallback reLoadList) {
  final provider = context.watch<ProviderProfile>();
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
          margin: const EdgeInsets.all(15),
          height: 200,
          child: Column(
            children: [
              const Text(
                'Thao  tác',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
              const Divider(
                thickness: 1,
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    OverlayEntry? overlayEntry;
                    overlayEntry = OverlayEntry(
                      builder: (BuildContext context) {
                        return GetEntry(
                          entry: overlayEntry,
                          nameCV: name,
                          onTap: () {
                            provider.deleteProfile(id);
                            reLoadList();
                            overlayEntry!.remove();
                          },
                        );
                      },
                    );
                    Overlay.of(context).insert(overlayEntry);
                  } catch (e) {
                    notifaceError(context, jsonDecode(e.toString())['message']);
                  }
                },
                child: Row(
                  children: [
                    SvgPicture.asset(
                      ImageFactory.delete,
                      color: Colors.black87,
                      width: 25,
                      height: 25,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    const Text(
                      'Xóa CV',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
            ],
          ));
    },
  );
}

// ignore: must_be_immutable
class GetEntry extends StatelessWidget {
  GetEntry(
      {super.key,
      required this.entry,
      required this.nameCV,
      required this.onTap});
  OverlayEntry? entry;
  final String nameCV;
  VoidCallback? onTap;

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
          top: (size.height / 2) - 100,
          left: 25,
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              height: 200,
              width: size.width - 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Bạn có chắn chắn muốn xóa $nameCV',
                    style: const TextStyle(color: primaryColor, fontSize: 16),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ButtonApp(
                          height: 60,
                          width: (size.width - 100) / 2,
                          title: 'Xác nhận',
                          onPress: onTap),
                      ButtonOutline(
                        height: 60,
                        width: (size.width - 100) / 2,
                        title: 'Hủy',
                        onPress: () {
                          entry!.remove();
                        },
                      ),
                    ],
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
