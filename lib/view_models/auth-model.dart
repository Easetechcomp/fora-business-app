import 'package:connectivity_plus/connectivity_plus.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:momentum/momentum.dart';

import '../controllers/auth-controller.dart';
import '../data_models/current-user-type.dart';

// View models are models which are associated to a View.
// Don't confuse these with the ViewModels of MVVM architecture.
// These are simply models which hold data for a view. The actions/events are still under the domain of a controller.

class AuthModel extends MomentumModel<AuthController> {
  final currentUser;
  final String email;
  final String area;
  final String birthDate;
  final isNotificationEnabled;
  final bool loginInProgress;
  final bool signUpInProgress;
  final bool surveyInProgress;
  final bool forgetPasswordInProgress;
  final connectionType;
  final hasInternet;
  final changePasswordTempToken;
  final wallet;
  final tempToken;
  final verified;

  AuthModel(AuthController controller,
      {required this.email,
      this.changePasswordTempToken,
      this.loginInProgress = false,
      this.signUpInProgress = false,
      this.surveyInProgress = false,
      this.currentUser,
      this.birthDate = '',
      this.isNotificationEnabled = false,
      this.forgetPasswordInProgress = false,
      this.connectionType,
      this.hasInternet,
      this.wallet,
      this.tempToken,
      this.verified = false,
      this.area = "sheikh zayed"})
      : super(controller);

  @override
  void update(
      {CurrentUserType? currentUser,
      String? email,
      bool? loginInProgress,
      bool? signUpInProgress,
      bool? surveyInProgress,
      bool? forgotPasswordInProgress,
      String? birthDate,
      String? area,
      bool? isNotificationEnabled,
      ConnectivityResult? connectionType,
      bool? hasInternet,
      String? changePasswordTempToken,
      final wallet,
      final tempToken,
      final verified}) {
    AuthModel(controller,
            email: email ?? this.email,
            surveyInProgress: surveyInProgress ?? this.surveyInProgress,
            loginInProgress: loginInProgress ?? this.loginInProgress,
            currentUser: currentUser ?? this.currentUser,
            signUpInProgress: signUpInProgress ?? this.signUpInProgress,
            birthDate: birthDate ?? this.birthDate,
            area: area ?? this.area,
            isNotificationEnabled:
                isNotificationEnabled ?? this.isNotificationEnabled,
            connectionType: connectionType ?? this.connectionType,
            hasInternet: hasInternet ?? this.hasInternet,
            changePasswordTempToken:
                changePasswordTempToken ?? this.changePasswordTempToken,
            wallet: wallet ?? this.wallet,
            verified: verified ?? this.verified,
            tempToken: tempToken ?? this.tempToken)
        .updateMomentum();
  }
}
