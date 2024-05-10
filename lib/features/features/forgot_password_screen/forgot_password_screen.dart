import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interective_cares_task/core/routes/route_name.dart';
import 'package:interective_cares_task/core/routes/router.dart';
import 'package:interective_cares_task/core/utils/consts/app_assets.dart';
import 'package:interective_cares_task/core/utils/consts/app_colors.dart';
import 'package:interective_cares_task/core/utils/consts/textStyle.dart';
import 'package:interective_cares_task/core/utils/extensions/extensions.dart';
import 'package:interective_cares_task/features/core/common_widgets/others_widget/elevated_button_widget.dart';
import 'package:interective_cares_task/features/features/signup_page/presentation/signup_page.dart';
import 'package:interective_cares_task/features/features/signup_page/riverpod_provider/provider.dart';
import 'package:interective_cares_task/main.dart';

import '../../core/common_widgets/others_widget/input_textfield_widget.dart';

class ForgotPasswordScreen extends ConsumerWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef widgetRef) {
    return Scaffold(
      body: Padding(
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
                    text: "Forgot Password",
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
                10.ph,
                globalText(
                    text:
                        "Enter email to send you an email to reset your password",
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal),
                60.ph,
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InputTextfiledWidget(
                      function: widgetRef.watch(email),
                      label: 'Enter your email address',
                      hint: 'example@gmail.com',
                      iconStatus: false,
                      specialCharacter: '',
                      keyWord: 'email',
                    ),
                  ],
                ),
                // 10.ph,

                // 20.ph,
                ElevatedButtonWidget(
                  buttonKeyWord: 'Send Email',
                  textColor: AppColors.blurDark,
                  textFontSize: 16.0,
                  textFontWeight: FontWeight.bold,
                  buttonWidth: double.infinity,
                  buttonHeight: 50.0,
                  callback: () async {
                    try {
                      await widgetRef
                          .read(firebaseAuthProvider)
                          .sendPasswordResetEmail(
                            email: widgetRef.watch(email.notifier).state,
                          );
                      if (!context.mounted) return;
                      RouteGenerator.pushNamed(context, Routes.dashboard);
                      snackbar(
                          message: "Successfully send email",
                          context: context,
                          color: Colors.green);
                    } catch (e) {
                      snackbar(
                          message: "$e", context: context, color: Colors.red);
                    }
                    // RouteGenerator.pushNamed(context, Routes.dashboard);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
