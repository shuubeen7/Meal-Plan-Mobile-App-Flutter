import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:meal_plan/features/admin/admin_home.dart';
import 'package:meal_plan/features/login/forgot_password.dart';
import 'package:meal_plan/features/login/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meal_plan/features/models/user.dart';
import 'package:meal_plan/features/user/user_home.dart';
import 'package:meal_plan/features/vendor/vendor_home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(children: [
          Column(
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
                    "Log in",
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
                alignment: Alignment.centerRight,
                margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ForgotPassword()));
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(
                        color: Color(0xff017be9), fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 30, right: 30, top: 20),
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
                        if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty){
                          login(emailController.text.trim(),
                              passwordController.text.trim());
                        }
                        else{
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
                    child: Text("Log in"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        shadowColor: Colors.transparent)),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Register to MealPlan as User?"),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const RegisterPage()));
                    },
                    child: const Text(
                      " Register",
                      style: TextStyle(
                          color: Color(0xff017be9),
                          fontWeight: FontWeight.w600),
                    ),
                  )
                ],
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
        ]),
      ),
    );
  }

  void login(String email, String password) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      final databaseRef = FirebaseDatabase.instance.ref("users");

      if (userCredential.user!.uid.isNotEmpty) {
        databaseRef.child(userCredential.user!.uid).once().then((value) async {


          if(value.snapshot.value == null){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Your account has been removed by admin."),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ));
            auth.signOut();
          }
          else{
            final json = value.snapshot.value as Map<dynamic, dynamic>;
            final user = UserModel.fromJson(json);
            print("Usersss ${user}");

            if(user.isBan){
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Your account has been banned."),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 2),
              ));
            }
            else{
              if (user.value == "admin") {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const AdminHome()),
                        (Route<dynamic> route) => false);
              }
              else if (user.value == "vendor") {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const VendorHome()),
                        (Route<dynamic> route) => false);
              }
              else {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const UserHome()),
                        (Route<dynamic> route) => false);
              }
            }
          }




        });

        setState(() {
          _isLoading = false;
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("No User Found with that email"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ));
        setState(() {
          _isLoading = false;
        });
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please check your password"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ));
        setState(() {
          _isLoading = false;
        });
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message.toString()),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ));
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
