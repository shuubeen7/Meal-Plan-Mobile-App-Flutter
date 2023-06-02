import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meal_plan/features/login/signup.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  var emailController = TextEditingController();


  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async{

    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Password reset link has been sent to your mail id"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ));


    }
    on FirebaseAuthException catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message.toString()),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ));

    }
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
                margin: EdgeInsets.only(left: 20),
                child: const Text(
                  "Forgot Password",
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
              margin: EdgeInsets.only(left: 20, right: 30, top: 20),
              child: Column(
                children: [
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email_outlined),
                        border: InputBorder.none,
                        hintText: "Enter Your Email",
                        hintStyle: TextStyle(color: Colors.grey)),
                    style: const TextStyle(
                      fontSize: 15,
                    ),
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
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
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
                    passwordReset();
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
}
