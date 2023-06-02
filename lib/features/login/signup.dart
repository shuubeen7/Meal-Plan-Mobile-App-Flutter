import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:meal_plan/features/login/email_verification.dart';

import '../admin/admin_home.dart';
import '../user/user_home.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children:[ Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
              ),
              Container(
                alignment: Alignment.center,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      "assets/images/logo.png",
                      height: 200,
                      width: 200,
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  margin: EdgeInsets.only(left: 20),
                  child: const Text(
                    "Register",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w500),
                  )),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20, right: 30, top: 20),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person_outline_rounded),
                          border: InputBorder.none,
                          hintText: "Enter Your Name",
                          hintStyle: TextStyle(color: Colors.grey)),
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      textAlignVertical: TextAlignVertical.center,
                    ),
                    Container(
                      height: 1,
                      color: Colors.grey,
                      margin: EdgeInsets.only(left: 45),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email_outlined),
                          border: InputBorder.none,
                          hintText: "Enter Your Email",
                          hintStyle: TextStyle(color: Colors.grey)),
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      textAlignVertical: TextAlignVertical.center,
                    ),
                    Container(
                      height: 1,
                      color: Colors.grey,
                      margin: EdgeInsets.only(left: 45),
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.lock_outline_rounded),
                          border: InputBorder.none,
                          hintText: "Enter Your Password",
                          hintStyle: TextStyle(color: Colors.grey)),
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      obscureText: true,
                      textAlignVertical: TextAlignVertical.center,
                    ),
                    Container(
                      height: 1,
                      color: Colors.grey,
                      margin: EdgeInsets.only(left: 45),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 30, right: 30, top: 30),
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xff00b0e9), Color(0xff017be9)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15)),
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                      });

                      if (emailController.text.isNotEmpty &&
                          passwordController.text.isNotEmpty) {

                        registerUser(
                            nameController.text.trim(),
                            emailController.text.trim(),
                            passwordController.text.trim());

                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Email and password cannot be empty"),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                        ));
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    },
                    child: Text("Register"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        shadowColor: Colors.transparent)),
              ),
              SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 15,
              )
            ],
          ),
            Container(
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.center,
              child:_isLoading ? CircularProgressIndicator() : SizedBox(),
            )
          ]
        ),
      ),
    );
  }

  void registerUser(String name, String email, String password) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (userCredential.user!.uid.isNotEmpty) {
        User? user = auth.currentUser;
        final uid = user?.uid;

        final databaseRef = FirebaseDatabase.instance.ref("users");

        await databaseRef.child(uid!).set(
            {'name': name, 'email': email, 'value': 'user', 'isBan': false});

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Success"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ));

        if(uid.isNotEmpty){
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const EmailVerificationScreen()));
        }


      }

      setState(() {
        _isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Email already exists"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ));
        setState(() {
          _isLoading = false;
        });
      } else if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please provide strong password"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ));
        setState(() {
          _isLoading = false;
        });
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message.toString()),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ));
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
