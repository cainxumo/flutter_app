import 'package:cloudbase_core/cloudbase_core.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/navigator/tab_navigator.dart';
import 'package:cloudbase_auth/cloudbase_auth.dart';
import 'package:travel_app/cloud.dart' as global;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  CloudBaseAuthState authState = await global.auth.getAuthState();
  if (authState == null||(authState!=null&&authState.authType == CloudBaseAuthType.ANONYMOUS)) {
    await global.auth.signInAnonymously().then((success) {
      print(success);
      runApp(MyApp());
    }).catchError((err) {
      print(err);
    });
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '国漫收藏馆',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TabNavigator(),
    );
  }
}

