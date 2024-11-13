import 'package:app/configs/route_path.dart';
import 'package:app/configs/uri.dart';
import 'package:app/modules/candidate/data/repositories/user_repositories.dart';
import 'package:app/modules/candidate/data/repositories/user_show_model.dart';
import 'package:app/modules/candidate/domain/providers/provider_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ItemCompanyChat extends StatefulWidget {
  const ItemCompanyChat(
      {super.key,
      required this.idUser,
      required this.idCompany,
      required this.lastMsgl});
  final String idUser;
  final String idCompany;
  final String lastMsgl;
  @override
  State<ItemCompanyChat> createState() => _ItemCompanyChatState();
}

class _ItemCompanyChatState extends State<ItemCompanyChat> {
  UserShow? user;

  UserRepositories userRepositories = UserRepositories();

  initData() async {
    user = await Modular.get<ProviderUser>().getUserById(widget.idUser);
    setState(() {});
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Modular.to.pushNamed(RoutePath.chatScreen, arguments: [
          widget.idCompany,
          widget.idUser,
          user!.firstName + user!.lastName,
          getAvatarUser(user!.avatar)
        ]);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 15),
        width: size.width,
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(width: 1, color: Colors.grey))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 12),
              height: 36.sp,
              width: 36.sp,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                image: DecorationImage(
                    image: NetworkImage(getAvatarUser(user?.avatar ?? '')),
                    fit: BoxFit.fill),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user?.firstName ?? '...'}  ${user?.lastName ?? ''}'.trim(),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  widget.lastMsgl,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
