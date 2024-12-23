import 'dart:convert';

import 'package:app/configs/image_factory.dart';
import 'package:app/configs/route_path.dart';
import 'package:app/configs/uri.dart';
import 'package:app/modules/candidate/data/models/apply_model.dart';
import 'package:app/modules/candidate/data/repositories/user_repositories.dart';
import 'package:app/modules/candidate/data/repositories/user_show_model.dart';
import 'package:app/modules/candidate/domain/providers/provider_auth.dart';
import 'package:app/modules/candidate/domain/providers/provider_user.dart';
import 'package:app/modules/candidate/presentations/themes/color.dart';
import 'package:app/shared/provider/provider_apply.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemCV extends StatefulWidget {
  const ItemCV({
    super.key,
    required this.apply,
    this.onApply,
  });

  final Apply apply;
  final Future Function()? onApply;

  @override
  State<ItemCV> createState() => _ItemCVState();
}

class _ItemCVState extends State<ItemCV> {
  UserShow? user;

  String avatar = '';

  UserRepositories userRepositories = UserRepositories();

  initData() async {
    user = await Modular.get<ProviderUser>().getUserById(widget.apply.userId);
    avatar = userRepositories.getAvatar(user?.avatar ?? 'user.png');
    setState(() {});
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  _saveRecently() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(kSaveRecently, jsonEncode(widget.apply.toJson()));
  }

  @override
  Widget build(BuildContext context) {
    context.watch<ProviderUser>();
    context.watch<ProviderAuth>();

    final x = (avatar != ''
        ? NetworkImage(avatar)
        : const AssetImage(ImageFactory.editCV)) as ImageProvider;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: GestureDetector(
        onTap: () async {
          final profile = await Modular.get<ProviderApply>()
              .getProfileByUserId(widget.apply.userProfileId);
          await Modular.to.pushNamed(RoutePath.pdfViewer,
              arguments: [profile.name, profile.pathCv, true, widget.apply.id]);
          await _saveRecently();
          if (widget.onApply != null) await widget.onApply!();
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(8.0)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 20, backgroundImage: x),
                  const SizedBox(width: 10.0),
                  Text(
                    '${user?.firstName} ${user?.lastName}',
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w500),
                  )
                ],
              ),
              const Text(
                'Ứng tuyển vị trí',
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
              Text(
                widget.apply.recruitmentName,
                style: const TextStyle(
                    fontWeight: FontWeight.w400, color: primaryColor),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(16.0)),
                child: const Text(
                  'Xem CV',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
