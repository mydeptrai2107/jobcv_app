import 'package:app/configs/route_path.dart';
import 'package:app/loading_screen.dart';
import 'package:app/modules/candidate/domain/providers/provider_app.dart';
import 'package:app/modules/candidate/domain/providers/provider_auth.dart';
import 'package:app/modules/candidate/presentations/views/chat/screens/chat_screen.dart';
import 'package:app/modules/candidate/presentations/views/profile/change_password_screen.dart';
import 'package:app/modules/recruiter/presentations/views/account/update_account_screen.dart';
import 'package:app/modules/recruiter/presentations/views/management/management_screen.dart';
import 'package:app/modules/recruiter/presentations/views/recruitment/detail_recruitment_screen.dart';
import 'package:app/shared/models/recruitment_model.dart';
import 'package:app/shared/presentations/login_register/verify_email.dart';
import 'package:app/shared/provider/provider_company.dart';
import 'package:app/modules/candidate/domain/providers/provider_profile.dart';
import 'package:app/shared/provider/provider_recruitment.dart';
import 'package:app/modules/candidate/domain/providers/provider_user.dart';
import 'package:app/modules/candidate/presentations/views/company/applied_screen.dart';
import 'package:app/modules/candidate/presentations/views/company/apply_screen.dart';
import 'package:app/modules/candidate/presentations/views/company/detail_recruitment.dart';
import 'package:app/modules/candidate/presentations/views/company/home_company.dart';

import 'package:app/modules/candidate/presentations/views/cv_profile/add_education_screen.dart';
import 'package:app/modules/candidate/presentations/views/cv_profile/add_skill_screen.dart';
import 'package:app/modules/candidate/presentations/views/cv_profile/add_working_experience_screen.dart';
import 'package:app/modules/candidate/presentations/views/cv_profile/create_cv_screen.dart';
import 'package:app/modules/candidate/presentations/views/cv_profile/fill_first_information_cv.dart';
import 'package:app/modules/candidate/presentations/views/cv_profile/fill_second_information_cv.dart';
import 'package:app/modules/candidate/presentations/views/cv_profile/list_profile_screen.dart';
import 'package:app/modules/candidate/presentations/views/cv_profile/pdf/preview_cv_screen.dart';
import 'package:app/modules/recruiter/presentations/views/recruitment/pdf_viewer_screen.dart';
import 'package:app/modules/candidate/presentations/views/cv_profile/welcome_create_cv.dart';
import 'package:app/modules/candidate/presentations/views/home/list_company_screen.dart';
import 'package:app/modules/candidate/presentations/views/home/search_company_screen.dart';
import 'package:app/modules/candidate/presentations/views/home/search_recruitment_screen.dart';
import 'package:app/modules/candidate/presentations/views/jobcv_home_screen.dart';
import 'package:app/modules/recruiter/data/provider/notification_provider.dart';
import 'package:app/modules/candidate/presentations/views/profile/recruitment_saved_screen.dart';
import 'package:app/modules/recruiter/data/provider/recruitment_provider.dart';
import 'package:app/modules/recruiter/presentations/views/account/recruiter_account_screen.dart';
import 'package:app/modules/recruiter/presentations/views/recruitment/add_recruitment.dart';
import 'package:app/modules/recruiter/presentations/views/notification/notification_screen.dart';
import 'package:app/modules/recruiter/presentations/views/recruiter_main.dart';
import 'package:app/shared/presentations/login_register/login.dart';
import 'package:app/shared/presentations/login_register/register.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'modules/recruiter/data/provider/recruiter_provider.dart';
import 'shared/provider/provider_apply.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {
    i.addSingleton(ProviderApp.new);
    i.addSingleton(RecruiterProvider.new);
    i.addSingleton(ProviderRecruitment.new);
    i.addSingleton(ProviderAuth.new);
    i.addSingleton(ProviderUser.new);
    i.addSingleton(ProviderProfile.new);
    i.addSingleton(ProviderCompany.new);
    i.addSingleton(ProviderApply.new);

    // if role Recruiter
    i.addSingleton(RecruitmentProvider.new);
    i.addSingleton(NotificationProvider.new);
  }

  @override
  void routes(RouteManager r) {
    r.child(
      RoutePath.loading,
      child: (context) => const LoadingScreen(),
    );
    r.child(
      RoutePath.home,
      child: (context) => const JobCVHomeScreen(),
    );
    r.child(
      RoutePath.login,
      child: (context) => const LoginScreen(),
    );
    r.child(
      RoutePath.register,
      child: (context) => const RegisterScreen(),
    );
    r.child(
      RoutePath.welcomeCreateCV,
      child: (context) => const WelcomeCreateCV(),
    );
    r.child(
      RoutePath.fillFirstInfoCV,
      child: (context) => const FillFirstInformationCV(),
    );
    r.child(
      RoutePath.createCV,
      child: (context) => CreateCVScreen(
        id: Modular.args.data[0],
        name: Modular.args.data[1],
        idUser: Modular.args.data[2],
        language: Modular.args.data[3],
      ),
    );
    r.child(
      RoutePath.fillSecondInfoCV,
      child: (context) => FillSecondInformationScreen(
        id: Modular.args.data[0],
        name: Modular.args.data[1],
        idUser: Modular.args.data[2],
      ),
    );
    r.child(
      RoutePath.addWorkingExperience,
      child: (context) => const AddWorkingExperienceScreen(),
    );
    r.child(
      RoutePath.addEducation,
      child: (context) => const AddEducationScreen(),
    );
    r.child(
      RoutePath.addSkill,
      child: (context) => const AddSkillScreen(),
    );
    r.child(
      RoutePath.previewCV,
      child: (context) => PreviewCVScreen(
        name: Modular.args.data[0],
        position: Modular.args.data[1],
        birthday: Modular.args.data[2],
        email: Modular.args.data[3],
        phoneNumber: Modular.args.data[4],
        link: Modular.args.data[5],
        git: Modular.args.data[6],
        address: Modular.args.data[7],
        careerGoals: Modular.args.data[8],
        experienceModel: Modular.args.data[9],
        schoolModell: Modular.args.data[10],
        idCV: Modular.args.data[11],
        nameCV: Modular.args.data[12],
        language: Modular.args.data[13],
      ),
    );
    r.child(
      RoutePath.mainRecruiter,
      child: (context) => const RecruiteMain(),
    );
    r.child(
      RoutePath.addRecruitment,
      child: (context) => AddRecruitmentScreen(
        recruitment:
            Modular.args.data != null ? Modular.args.data as Recruitment : null,
      ),
    );
    r.child(
      RoutePath.deatilRecruitmentScreen,
      child: (context) => const DetailRecruitmentScreen(),
    );
    r.child(
      RoutePath.notification,
      child: (context) => const NotificationScreen(),
    );
    r.child(
      RoutePath.recruiterAccount,
      child: (context) => const RecruiterAccountScreen(),
    );
    r.child(
      RoutePath.listProfile,
      child: (context) => const ListProfileScreen(),
    );
    r.child(
      RoutePath.pdfViewer,
      child: (context) => PDFViewerScreen(
        name: Modular.args.data[0],
        pathCV: Modular.args.data[1],
        recruiterSeen: Modular.args.data[2],
        id: Modular.args.data[3],
      ),
    );
    r.child(
      RoutePath.homeCompany,
      child: (context) => CompanyHome(
        company: Modular.args.data[0],
      ),
    );
    r.child(
      RoutePath.detailRecruitment,
      child: (context) => DetailRecruitment(
        recruitment: Modular.args.data[0],
        company: Modular.args.data[1],
      ),
    );
    r.child(
      RoutePath.applyScreen,
      child: (context) => ApplyScreen(
        recruitment: Modular.args.data[0],
        idComapny: Modular.args.data[1],
      ),
    );
    r.child(
      RoutePath.listCompanyScreen,
      child: (context) => const ListCompanyScreen(),
    );
    r.child(
      RoutePath.searchCompanyScreen,
      child: (context) => const SearchScreen(),
    );
    r.child(
      RoutePath.searchRecruitmentScreen,
      child: (context) => const SearchRecruitmentScreen(),
    );
    r.child(
      RoutePath.verifyEmail,
      child: (context) => const VerifyEmail(),
    );
    r.child(
      RoutePath.appliedScreen,
      child: (context) => const AppliedScreen(),
    );
    r.child(
      RoutePath.recruitmentSavedScreen,
      child: (context) => RecruitmentSavedScreen(
        loadCount: Modular.args.data[0],
      ),
    );
    r.child(
      RoutePath.chatScreen,
      child: (context) => ChatScreen(
        currentUserId: Modular.args.data[0],
        friendId: Modular.args.data[1],
        friendName: Modular.args.data[2],
        friendImage: Modular.args.data[3],
      ),
    );
    r.child(
      RoutePath.changePWScreen,
      child: (context) => const ChangePassWordScreen(),
    );
    r.child(
      RoutePath.managementCV,
      child: (context) => const ManagementScreen(),
    );
    r.child(
      RoutePath.updateAccount,
      child: (context) => const UpdateAccountScreen(),
    );
  }
}
