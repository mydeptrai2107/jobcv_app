import 'package:app/configs/route_path.dart';
import 'package:app/configs/uri.dart';
import 'package:app/modules/recruiter/data/provider/recruiter_provider.dart';
import 'package:app/shared/provider/provider_company.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:ionicons/ionicons.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final me = context.watch<RecruiterProvider>((p) => p.recruiter).recruiter;
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 41, 63, 78),
      title: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.black12,
            backgroundImage:
                NetworkImage(getAvatarCompany(me.avatar.toString())),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  me.name,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  me.contact,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          ActionButton(
            isNotification: true,
            assetIcon: Ionicons.notifications,
            callback: () => Modular.to.pushNamed(RoutePath.notification),
          ),
          ActionButton(
            assetIcon: Ionicons.settings,
            callback: () async {
              await Modular.get<ProviderCompany>().getCompanyById(
                  Modular.get<RecruiterProvider>().recruiter.id);
              Modular.to.pushNamed(RoutePath.recruiterAccount);
            },
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class ActionButton extends StatefulWidget {
  final bool isNotification;
  final IconData assetIcon;
  final VoidCallback callback;
  const ActionButton(
      {super.key,
      required this.assetIcon,
      required this.callback,
      this.isNotification = false});

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  List<RemoteMessage> _messages = [];
  @override
  void initState() {
    super.initState();
    if (widget.isNotification) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        setState(() {
          _messages = [..._messages, message];
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final value = widget.isNotification ? _messages.length.toString() : null;
    return Stack(
      children: [
        IconButton(
            onPressed: widget.callback,
            style: IconButton.styleFrom(
                backgroundColor: Colors.grey.withOpacity(0.5)),
            icon: Icon(
              widget.assetIcon,
              size: 25,
              color: Colors.white,
            )),
        if (value != null)
          Positioned(
              right: 0,
              child: CircleAvatar(
                radius: 8,
                backgroundColor: Colors.red,
                child: Center(
                    child: Text(
                  value,
                  style: const TextStyle(fontSize: 10, color: Colors.white),
                )),
              ))
      ],
    );
  }
}
