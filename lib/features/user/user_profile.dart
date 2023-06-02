import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:meal_plan/features/login/login.dart';
import 'package:meal_plan/features/models/user.dart';

import '../login/reset_password.dart';
import 'order_list.dart';



class UserProfile extends StatelessWidget {
  const UserProfile({Key? key}) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    try {

      final auth = FirebaseAuth.instance;
      await auth.signOut();
      await Hive.deleteBoxFromDisk('cart');
      Navigator.of(context)
          .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const LoginPage()), (Route<dynamic> route) => false);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    var doc = FirebaseDatabase.instance.ref("users").child(auth.currentUser!.uid);
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
        ),
        body: FutureBuilder(
          future: doc.get(),
          builder: (_, snapshot){

            if (snapshot.hasData) {
              Map<dynamic, dynamic> data = snapshot.data?.value as Map;
              UserModel user = UserModel.fromJson(data);
              var name = user.name;
              var email = user.email;
              return _buildProfilePage(context, name, email);
            }

            return const Center(
              child: SizedBox(
                  height: 40.0,
                  width: 40.0,
                  child:CircularProgressIndicator()),
            );
          },
        )
    );
  }

  Widget _buildProfilePage(BuildContext context, String name, String email) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.35,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 50.0),
                child: SizedBox(
                  width: 100.0,
                  height: 100.0,
                  child: CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/images/profile.png')),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text(
                  name,
                  style: const TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 7.0),
                child: Text(
                  email,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 11.0),
                child: Divider(
                  indent: 10.0,
                  endIndent: 10.0,
                  height: 1.0,
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ),
        ),

        InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => OrderList()));
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(10),
            height: 50,
            child: Card(
              elevation: 5,
              child: Align(
                alignment: Alignment.center,
                child: Row(
                  children: const [
                    SizedBox(width: 10,),
                    Icon(Icons.list),
                    SizedBox(width: 10,),
                    Text("My Orders", style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500
                    ),),
                    Spacer(),
                    Icon(Icons.arrow_right),
                    SizedBox(width: 10,),
                  ],
                ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPassword()));
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(10),
            height: 50,
            child: Card(
              elevation: 5,
              child: Align(
                alignment: Alignment.center,
                child: Row(
                  children: const [
                    SizedBox(width: 10,),
                    Icon(Icons.list),
                    SizedBox(width: 10,),
                    Text("Reset Password", style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500
                    ),),
                    Spacer(),
                    Icon(Icons.arrow_right),
                    SizedBox(width: 10,),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 50, right: 50, top: 20),
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xff00b0e9), Color(0xff017be9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15)),
          child: ElevatedButton(
              onPressed: () {
                _signOut(context);
              },
              child: Text("Logout"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  shadowColor: Colors.transparent)),
        ),
      ],
    );
  }
}
