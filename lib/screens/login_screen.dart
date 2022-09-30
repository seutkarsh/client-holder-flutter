import 'package:client_holder/controllers/authentication.dart';
import 'package:client_holder/screens/home_page_screen.dart';
import 'package:client_holder/screens/signup_screen.dart';
import 'package:client_holder/utils/colors.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:password_validator/password_validator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
//firebase auth instance
  final auth = FirebaseAuth.instance;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  PasswordValidator passwordValidator = new PasswordValidator(min: 6);
  final loginkey = GlobalKey<FormState>(); //key for login form

  //login handler
  void login() {
    if (loginkey.currentState!.validate()) {
      loginkey.currentState!.save();
      final _email = _emailController.text.trim();
      final _password = _passwordController.text.trim();
      print("passowrd: " + _password);
      signin(_email, _password, context).then((value) {
        if (value != null) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(uid: value.uid),
              ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade400,
        foregroundColor: Colors.white,
        title: Text("Login"),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 25),
        width: double.infinity,
        // color: Colors.grey,
        child: Form(
          key: loginkey,
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
              //Login Button
              SizedBox(height: 35),
              ElevatedButton(
                  onPressed: () {
                    //login function
                    login();
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 20),
                  )),
              //Signup
              SizedBox(height: 35),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: "New Here, ",
                        style: TextStyle(color: Colors.black)),
                    TextSpan(
                        text: "Sign Up",
                        style: TextStyle(color: Colors.blue),
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () => {
                                //navigate to signup
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignupScreen()))
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
