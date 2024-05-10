import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interective_cares_task/core/app_component/app_component.dart';
import 'package:interective_cares_task/core/utils/extensions/extensions.dart';

import 'core/routes/route_name.dart';
import 'core/routes/router.dart';
import 'core/utils/consts/textStyle.dart';
import 'features/core/common_widgets/others_widget/elevated_button_widget.dart';
import 'features/features/course_details_play/course_details_play_tutorial.dart';
import 'features/features/course_details_play/data/model/course_model.dart';
import 'features/features/course_details_play/data/services/course_services.dart';
import 'features/features/course_details_play/presentation/call_function.dart';
import 'features/features/signup_page/riverpod_provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyCYFM4LcjKVi16EhELhktsL4VxCMjmPYJ8",
          appId: "1:921804076386:android:e5bb2de8f575da3627283b",
          messagingSenderId: "921804076386",
          projectId: "interact-care-task"));
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: RouteGenerator.onRouteGenerate,
    );
  }
}
