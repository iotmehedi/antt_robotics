import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:interective_cares_task/core/utils/consts/app_assets.dart';
import 'package:interective_cares_task/core/utils/consts/app_colors.dart';
import 'package:interective_cares_task/core/utils/consts/textStyle.dart';
import 'package:interective_cares_task/core/utils/extensions/extensions.dart';
import 'package:interective_cares_task/features/core/common_widgets/others_widget/elevated_button_widget.dart';
import 'package:interective_cares_task/features/features/signup_page/presentation/signup_page.dart';
import 'package:interective_cares_task/features/features/signup_page/riverpod_provider/provider.dart';
import 'package:interective_cares_task/main.dart';
import '../../core/routes/route_name.dart';
import '../../core/routes/router.dart';
import '../core/common_widgets/others_widget/input_textfield_widget.dart';

class SigninScreen extends ConsumerWidget {
  SigninScreen({super.key});

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
                    text: "Sign In",
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
                10.ph,
                globalText(
                    text:
                        "By using our services you are agreeing to our terms and\nprivacy Statement",
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
                    10.ph,
                    InputTextfiledWidget(
                      function: widgetRef.watch(password),
                      label: 'Enter your password',
                      hint: '123s',
                      iconStatus: false,
                      length: 8,
                      specialCharacter: '',
                      keyWord: 'password',
                    ),
                  ],
                ),
                // 10.ph,
                Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () {
                          RouteGenerator.pushNamed(
                              context, Routes.forgotPasswordScreen);
                        },
                        child: Text("Forgot Password?"))),
                // 20.ph,
                ElevatedButtonWidget(
                  buttonKeyWord: 'Sign In',
                  textColor: AppColors.blurDark,
                  textFontSize: 16.0,
                  textFontWeight: FontWeight.bold,
                  buttonWidth: double.infinity,
                  buttonHeight: 50.0,
                  callback: () async {
                    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
                    //   return MyHomePage();
                    // }));
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));

                    try {
                      await widgetRef
                          .read(firebaseAuthProvider)
                          .signInWithEmailAndPassword(
                            email: widgetRef.watch(email.notifier).state,
                            password: widgetRef.watch(password.notifier).state,
                          );
                      if (!context.mounted) return;
                      // RouteGenerator.pushNamed(context, Routes.dashboard);
                      snackbar(
                          message: "successfully signin",
                          context: context,
                          color: Colors.green);
                    } catch (e) {
                      snackbar(
                          message: "Email or password is wrong",
                          context: context,
                          color: Colors.red);
                    }
                    // RouteGenerator.pushNamed(context, Routes.dashboard);
                  },
                ),
10.ph,
                ElevatedButtonWidget(
                  buttonKeyWord: 'Google Sign in',
                  textColor: AppColors.blurDark,
                  textFontSize: 16.0,
                  textFontWeight: FontWeight.bold,
                  buttonWidth: double.infinity,
                  buttonHeight: 50.0,
                  callback: () => _handleSignIn(context),
                ),

                40.ph,
                RichText(
                  text: TextSpan(
                    text: 'New Here? ',
                    style: const TextStyle(color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Create an account',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            RouteGenerator.pushNamed(
                                context, Routes.signupScreen);
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
      ),
    );
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void _handleSignIn(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        // Successfully signed in
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "Signed in successfully: ${googleSignInAccount.displayName}"),
        ));
      } else {
        // User canceled the sign-in
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Sign in canceled"),
        ));
      }
    } catch (error) {
      print("Error signing in with Google: $error");
      // Handle sign-in errors
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error signing in with Google: $error"),
      ));
    }
  }
}
