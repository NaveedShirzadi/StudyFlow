import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String userIcon = "assets/images/UserIcon1.png";
String keyIcon = "assets/images/key_icon.png";

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold (
      body: Container(
        height: double.maxFinite,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 47, 158, 249),
              Color.fromARGB(255, 197, 227, 252)
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(size.height * 0.040),
            child: Column(
              children: [
                Image.asset("assets/images/Image1.png"),
                SizedBox(height: size.height * 0.018),
                Text(
                  "Welcome Back!", 
                  textAlign: TextAlign.center,
                  style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                ),
                SizedBox(height: size.height * 0.007),
                Text(
                  "Please, Log In.", 
                  textAlign: TextAlign.center,
                  style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                )
                ),
                SizedBox(height: size.height * 0.03),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    filled: true,
                    hintText: "Email",
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset(userIcon, width: 20),
                      ),
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                     borderRadius: BorderRadius.circular(37),
                  ) 
                ),
                ),
                SizedBox(height: size.height * 0.025),
                TextField(  
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    filled: true,
                    hintText: "Password",
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset(keyIcon, width: 20),
                      ),
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                     borderRadius: BorderRadius.circular(37),
                  ) 
                ),  
                ),
                SizedBox(height: size.height * 0.02),
                CupertinoButton(
                  padding: EdgeInsets.zero, 
                  child: Container(
                    alignment: Alignment.center,
                    height: size.height * 0.080,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 125, 205, 249),
                      borderRadius: BorderRadius.circular(37),
                    ),
                    child: const Text(
                      "Continue", 
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      )
                  ),
                  onPressed: () {},
                  ),
                  SizedBox(height: size.height * 0.04),
                Row(
                    children: [
                      Expanded(
                        child: Divider(
                          height: 1,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: size.width * 0.02),
                      Text(
                        "OR", 
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: size.width * 0.02),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.white,
                        ),
                      ),
                    ]
                ),
                SizedBox(height: size.height * 0.04),
                CupertinoButton(
                  padding: EdgeInsets.zero, 
                  child: Container(
                    alignment: Alignment.center,
                    height: size.height * 0.080,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 125, 205, 249),
                      borderRadius: BorderRadius.circular(37),
                    ),
                    child: const Text(
                      "Create an Account", 
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      )
                  ),
                  onPressed: () {},
                  ),
              ]
                )
            )
              )
            )
    );
  }
}