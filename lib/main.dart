import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:meal_plan/features/hiveModels/product_model.dart';
import 'package:meal_plan/features/login/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meal_plan/firebase_options.dart';

import 'features/admin/admin_home.dart';
import 'features/models/user.dart';
import 'features/user/user_home.dart';
import 'features/vendor/vendor_home.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Hive.initFlutter();
  Hive.registerAdapter(HiveProductModelAdapter());


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: home(context),
        initialData: splashScreen(),
        builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
          print("Snap ${snapshot.requireData}");
          return snapshot.requireData;
        },
      )
    );
  }


  Future<Widget> home(BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    final currentUser = auth.currentUser;
    if(currentUser != null){
      final databaseRef = FirebaseDatabase.instance.ref("users");
      late UserModel? user;

      await databaseRef
          .child(currentUser.uid)
          .once()
          .then((value) {

        if(value.snapshot.value == null){
         user = null;
        }

        final json  = value.snapshot.value as Map<dynamic, dynamic>;

        user = UserModel.fromJson(json);
        print("User Value Home ${user?.value}");
      });

      print("User $user");

      if(user == null){
        auth.signOut();
        return LoginPage();
      }

      if(user!.isBan){
        auth.signOut();
        return LoginPage();
      }
      else{
        if(user!.value == "admin") {
          return const AdminHome();
        }
        else if(user!.value == "vendor"){
          return const VendorHome();
        }
        else {
          return const UserHome();
        }
      }


    }
    else{
      return const LoginPage();
    }
  }

  Widget splashScreen(){
    return Scaffold(
      body:  Container(
        alignment: Alignment.center,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Image.asset(
              "assets/images/logo.png",
              height: 120,
              width: 120,
            )),
      ),
    );
  }
}
