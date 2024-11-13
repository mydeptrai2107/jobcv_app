import 'package:app/app_module.dart';
import 'package:flutter/foundation.dart';
import 'modules/candidate/data/models/hive_models/experience_model.dart';
import 'modules/candidate/data/models/hive_models/experience_model.g.dart';
import 'modules/candidate/data/models/hive_models/school_model.dart';
import 'modules/candidate/data/models/hive_models/school_model.g.dart';
import 'modules/candidate/data/models/hive_models/skill_model.dart';
import 'modules/candidate/data/models/hive_models/skill_model.g.dart';
import 'modules/candidate/data/models/hive_models/user_model_hive.dart';
import 'modules/candidate/data/models/hive_models/user_model_hive.g.dart';
import 'package:app/firebase_options.dart';
import 'package:app/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'shared/service/fcm.dart';
import 'shared/service/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) async {
    await Hive.initFlutter();
    Hive.registerAdapter(ExperienceModelAdapter());
    Hive.registerAdapter(SchoolModelAdapter());
    Hive.registerAdapter(SkillModelAdapter());
    Hive.registerAdapter(UserModelAdapter());

    await Hive.openBox<ExperienceModel>('Experience');
    await Hive.openBox('info');
    await Hive.openBox<SchoolModel>('school');
    await Hive.openBox<SkillModel>('skill');
    await Hive.openBox<UserModelHive>('user');

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    NotificationService notificationService = NotificationService();
    await notificationService.init();
    // Set the background messaging handler early on, as a named top-level function
    setupFirebaseMessage();
    if (!kIsWeb) {
      await setupFlutterNotifications();
    }
    runApp(ModularApp(module: AppModule(), child: const App()));
  });
}
