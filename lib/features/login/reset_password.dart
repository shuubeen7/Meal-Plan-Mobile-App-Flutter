import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meal_plan/features/login/signup.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  var passwordController = TextEditingController();


  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
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
                margin: const EdgeInsets.only(left: 20),
                child: const Text(
                  "Reset Password",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.w500),
                )),
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              margin: const EdgeInsets.only(left: 20, right: 30, top: 20),
              child: Column(
                children: [
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email_outlined),
                        border: InputBorder.none,
                        hintText: "Enter New Password",
                        hintStyle: TextStyle(color: Colors.grey)),
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                    textAlignVertical: TextAlignVertical.center,
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey,
                    margin: const EdgeInsets.only(left: 45),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              margin: const EdgeInsets.only(left: 30, right: 30, top: 30),
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff00b0e9), Color(0xff017be9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15)),
              child: ElevatedButton(
                  onPressed: () {
                    if (passwordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Password cannot be empty"), backgroundColor: Colors.red,));
                    }
                    else {
                      _changePassword(passwordController.text);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      shadowColor: Colors.transparent),
                  child: const Text("Reset Password")
              ),
            ),

            const SizedBox(height: 15,),
          ],
        ),
      ),
    );
  }


  void _changePassword(String newPassword) async {
    var user = await FirebaseAuth.instance.currentUser!;

    try {
      user.updatePassword(newPassword).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Successfully changed password"), backgroundColor: Colors.green,));
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Password can't be changed$error"), backgroundColor: Colors.red,));
        //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("No user found for that email."), backgroundColor: Colors.red,));
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Wrong password provided for that user."), backgroundColor: Colors.red,));
      }
    }
  }


}
