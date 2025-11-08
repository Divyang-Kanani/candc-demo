import 'dart:developer';

import 'package:candc_demo_flutter/dialog/custom_progress_dialog.dart';
import 'package:candc_demo_flutter/screen/my_task_screen/my_task_screen.dart';
import 'package:candc_demo_flutter/screen/register_screen/register_screen.dart';
import 'package:candc_demo_flutter/utils/shared_pref_helper.dart';
import 'package:candc_demo_flutter/utils/string_extension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/internet_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passFocus = FocusNode();
  bool isPasswordVisible = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.white.withValues(alpha: 0.96),
        forceMaterialTransparency: true,
      ),
      backgroundColor: Colors.white.withValues(alpha: 0.96),
      body: SafeArea(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.withValues(alpha: 0.2),
                    ),
                    child: Center(
                      child: Icon(Icons.check_circle, color: Colors.blueAccent),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Welcome Back',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Log in to manage your task',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email'),
                        SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.purple.withValues(alpha: 0.2),
                            ),
                          ),
                          padding: EdgeInsets.all(4),
                          child: Row(
                            children: [
                              SizedBox(width: 8),
                              Icon(
                                Icons.email,
                                color: Colors.purple.withValues(alpha: 0.5),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: emailController,
                                  focusNode: emailFocus,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter your email address',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Password'),
                        SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.purple.withValues(alpha: 0.2),
                            ),
                          ),
                          padding: EdgeInsets.all(4),
                          child: Row(
                            children: [
                              SizedBox(width: 8),
                              Icon(
                                Icons.lock,
                                color: Colors.purple.withValues(alpha: 0.5),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: passwordController,
                                  keyboardType: TextInputType.visiblePassword,
                                  focusNode: passFocus,
                                  textInputAction: TextInputAction.done,
                                  obscuringCharacter: '*',
                                  obscureText: isPasswordVisible ? false : true,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Enter your password',
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                                child: Icon(
                                  isPasswordVisible
                                      ? CupertinoIcons.eye
                                      : CupertinoIcons.eye_slash_fill,
                                  color: Colors.purple.withValues(alpha: 0.5),
                                ),
                              ),
                              SizedBox(width: 8),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(color: Colors.indigo),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  InkWell(
                    onTap: () => login(),
                    child: Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? "),
                      SizedBox(width: 2),
                      InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(),
                          ),
                        ),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
    emailFocus.unfocus();
    passFocus.unfocus();
    final emailValue = emailController.text;
    final passValue = passwordController.text;

    if (!emailValue.isValidEmail) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid or empty email ❌'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else if (passValue.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password cannot be empty ❌'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      if (await InternetConnection.instance.hasConnection()) {
        CustomProgressDialog.show();
        try {
          final credential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                email: emailValue,
                password: passValue,
              );
          log(credential.user.toString());
          CustomProgressDialog.dismiss();
          if (credential.user != null) {
            await SharedPrefHelper().setBool('isUserLoggedIn', true);
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => MyTaskScreen()),
              (route) => false,
            );
          }
        } on FirebaseAuthException catch (e) {
          CustomProgressDialog.dismiss();
          if (e.code == 'user-not-found') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('No user found for that email.'),
                behavior: SnackBarBehavior.floating,
              ),
            );
            print('No user found for that email.');
          } else if (e.code == 'wrong-password') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('No user found for that email.'),
                behavior: SnackBarBehavior.floating,
              ),
            );
            print('Wrong password provided for that user.');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.message ?? 'Something went wrong'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        } catch (e) {
          CustomProgressDialog.dismiss();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }
}
