import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interective_cares_task/core/utils/extensions/extensions.dart';

import '../../../../core/routes/route_name.dart';
import '../../../../core/routes/router.dart';
import '../../../../core/utils/consts/app_assets.dart';
import '../../../../core/utils/consts/app_colors.dart';
import '../../../../core/utils/consts/textStyle.dart';
import '../../../core/common_widgets/others_widget/elevated_button_widget.dart';
import '../../../core/common_widgets/others_widget/input_textfield_widget.dart';
import '../riverpod_provider/provider.dart';

class SignupScreen extends ConsumerWidget {
  SignupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      onWillPop: () async {
        ref.read(isEmailEmpty.notifier).state = false;
        ref.read(isPasswordEmpty.notifier).state = false;
        ref.read(isConfirmPasswordEmpty.notifier).state = false;
        ref.read(isBothPasswordSame.notifier).state = false;
        ref.read(confirmPasswordVisibility.notifier).state = false;
        ref.read(passwordVisibility.notifier).state = false;
        ref.watch(email.notifier).state = '';
        ref.watch(password.notifier).state = '';
        ref.watch(confirmPassword.notifier).state = '';
        return true;
      },
      child: Scaffold(
        body: Consumer(builder: (context, ref, _) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppAssets.logo,
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width * 0.3,
                    ),
                    headingText(
                        text: "Create an account",
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                    60.ph,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InputTextfiledWidget(
                          function: ref.watch(email),
                          label: 'Enter your email address',
                          hint: 'example@gmail.com',
                          iconStatus: false,
                          specialCharacter: '',
                          keyWord: 'email',
                        ),
                        3.ph,
                        Visibility(
                            visible: ref.watch(isEmailEmpty) == true &&
                                    ref.watch(email).isEmpty
                                ? true
                                : false,
                            child: globalText2(
                                text: "Email is Empty",
                                color: Colors.red,
                                fontSize: 12.0,
                                fontWeight: FontWeight.normal)),
                        10.ph,
                        InputTextfiledWidget(
                          function: ref.watch(password),
                          label: 'Enter your password',
                          hint: '123s',
                          iconStatus: false,
                          length: 8,
                          specialCharacter: '',
                          keyWord: 'password',
                        ),
                        3.ph,
                        Visibility(
                            visible: ref.watch(isPasswordEmpty) == true &&
                                    ref.watch(password).isEmpty
                                ? true
                                : false,
                            child: globalText2(
                                text: "Password is Empty",
                                color: Colors.red,
                                fontSize: 12.0,
                                fontWeight: FontWeight.normal)),
                        10.ph,
                        InputTextfiledWidget(
                          function: ref.watch(confirmPassword),
                          label: 'Confirm your password',
                          hint: '123s',
                          iconStatus: false,
                          length: 8,
                          specialCharacter: '',
                          keyWord: 'confirmPassword',
                        ),
                        3.ph,
                        Visibility(
                            visible:
                                ref.watch(isConfirmPasswordEmpty) == true &&
                                        ref.watch(confirmPassword).isEmpty
                                    ? true
                                    : false,
                            child: globalText2(
                                text: "Confirm password is Empty",
                                color: Colors.red,
                                fontSize: 12.0,
                                fontWeight: FontWeight.normal)),
                      ],
                    ),
                    30.ph,
                    ElevatedButtonWidget(
                      buttonKeyWord: 'Sign Up',
                      textColor: AppColors.blurDark,
                      textFontSize: 16.0,
                      textFontWeight: FontWeight.bold,
                      buttonWidth: double.infinity,
                      buttonHeight: 50.0,
                      callback: () async {
                        if (ref.watch(email.notifier).state.isEmpty) {
                          ref.read(isEmailEmpty.notifier).state = true;
                        }
                        if (ref.watch(password.notifier).state.isEmpty) {
                          ref.read(isPasswordEmpty.notifier).state = true;
                        }
                        if (ref.watch(confirmPassword.notifier).state.isEmpty) {
                          ref.read(isConfirmPasswordEmpty.notifier).state =
                              true;
                        }
                        if (ref.watch(password.notifier).state !=
                            ref.watch(confirmPassword.notifier).state) {
                          snackbar(
                              message: 'Both password is not matched',
                              context: context,
                              color: Colors.red);
                        }
                        if (ref.watch(password.notifier).state.isNotEmpty &&
                            ref.watch(email.notifier).state.isNotEmpty &&
                            ref
                                .watch(confirmPassword.notifier)
                                .state
                                .isNotEmpty) {
                          try {
                            await ref
                                .watch(firebaseAuthProvider)
                                .createUserWithEmailAndPassword(
                                  email: ref.watch(email.notifier).state,
                                  password: ref.watch(password.notifier).state,
                                );
                            if (!context.mounted) return;
                            snackbar(
                                message: "Successfully Sign up",
                                context: context,
                                color: Colors.green);
                            RouteGenerator.pushNamed(
                                context, Routes.signInScreen);
                          } on FirebaseAuthException catch (e) {
                            snackbar(
                                message: e.message.toString(),
                                context: context,
                                color: Colors.red);
                          }
                        }
                      },
                    ),
                    40.ph,
                    RichText(
                      text: TextSpan(
                        text: 'Have an account?     ',
                        style: const TextStyle(color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Sign In',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                RouteGenerator.pushNamed(
                                    context, Routes.signInScreen);
                              },
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.blurDark),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackbar(
    {required String message,
    required BuildContext context,
    required MaterialColor color}) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: color,
    content: Text(message),
  ));
}
