import 'package:client_holder/controllers/authentication.dart';
import 'package:client_holder/screens/home_page_screen.dart';
import 'package:client_holder/screens/login_screen.dart';
import 'package:client_holder/utils/colors.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:password_validator/password_validator.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  //firebase suth instance
  final auth = FirebaseAuth.instance;
//TextEditing Controllers
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  PasswordValidator passwordValidator = new PasswordValidator(min: 6);
  final signupkey = GlobalKey<FormState>(); //key for login form

  void handleSignup() {
    if (signupkey.currentState!.validate()) {
      signupkey.currentState!.save();
      final _email = _emailController.text.trim();
      final _password = _passwordController.text.trim();
      signUp(_email, _password, context).then((value) {
        if (value != null) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(uid: value.uid)));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade400,
        title: Text("SignUp"),
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 25),
        width: double.infinity,
        // color: Colors.grey,
        child: Form(
          key: signupkey,
          child: Column(
            children: [
              SizedBox(height: 40),
              //Email Input Field
              TextFormField(
                controller: _emailController,
                cursorColor: secondaryColor,
                decoration: InputDecoration(
                    labelText: "Email", labelStyle: TextStyle(fontSize: 15)),
                validator: (value) => EmailValidator.validate(value!)
                    ? null
                    : "Please enter a valid email",
              ),
              SizedBox(height: 25),
              //Password Input Field
              TextFormField(
                controller: _passwordController,
                cursorColor: secondaryColor,
                decoration: InputDecoration(
                    labelText: "Password", labelStyle: TextStyle(fontSize: 15)),
                validator: (value) => passwordValidator.validate(value!)
                    ? null
                    : "Password must be of min 6 letters and contain 1 uppercase letter ",
              ),
              SizedBox(height: 25),
              //Confirm Password Input Field
              TextFormField(
                  controller: _confirmPasswordController,
                  cursorColor: secondaryColor,
                  decoration: InputDecoration(
                      labelText: "Confirm Password",
                      labelStyle: TextStyle(fontSize: 15)),
                  validator: (value) => _passwordController.value ==
                          _confirmPasswordController.value
                      ? null
                      : "Password Doesn't Match"),
              //Login Button
              SizedBox(height: 35),
              ElevatedButton(
                  onPressed: () {
                    handleSignup();
                  },
                  child: Text(
                    "Register",
                    style: TextStyle(fontSize: 20),
                  )),
              //Signup
              SizedBox(height: 35),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: "Already Registered, ",
                        style: TextStyle(color: Colors.black)),
                    TextSpan(
                        text: "Login",
                        style: TextStyle(color: Colors.blue),
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () => {
                                //navigate to signup
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()))
                              })
                  ],
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
