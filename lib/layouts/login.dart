import 'package:shared_preferences/shared_preferences.dart';

import '../layouts/home.dart';
import '../layouts/toaster.dart';
import '../resources/colors.dart';
import '../layouts/signup.dart';
import '../logics/auth_controller.dart';
import 'package:flutter/material.dart';

TextEditingController _emailPhone = TextEditingController();
TextEditingController _password = TextEditingController();
late SharedPreferences _prefs;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    initial();
  }

  initial() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 400,
                    child: Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/images/street-signs.png",
                              width: 150,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Emergency Alert Responder",
                              style: TextStyle(
                                fontFamily: "adventPro",
                                fontSize: 20,
                                color: lightRed,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Wrap(
                              children: const [
                                Text(
                                  "Please Login to continue",
                                  softWrap: true,
                                  style: TextStyle(
                                      fontFamily: "vt323", fontSize: 20),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _emailPhone,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  label: const Text("Email"),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(0))),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: _password,
                              obscureText: true,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  label: const Text("Password"),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(0))),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextButton(
                              onPressed: () async {
                                _emailPhone.text =
                                    _emailPhone.text.replaceAll(" ", "");
                                if (_emailPhone.text.isNotEmpty &&
                                    _password.text.isNotEmpty) {
                                  await AuthUser(
                                    email: _emailPhone.text,
                                    password: _password.text,
                                    context: context,
                                  ).login().then((value) {
                                    if (value?.user == null) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginPage()));
                                    }
                                  });
                                } else {
                                  AwesomeToaster.showToast(
                                      context: context,
                                      msg: "Please fill all the fields");
                                }
                              },
                              style: ButtonStyle(
                                  minimumSize: MaterialStateProperty.all(
                                      const Size(double.infinity, 60)),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.blue)),
                              child: const Text(
                                "Log in",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text("OR",
                                style: TextStyle(color: Colors.grey)),
                            TextButton.icon(
                              icon: const Icon(
                                Icons.wifi_off_rounded,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                                if (_prefs.getBool(
                                            "isResponderLoggedinBefore") !=
                                        null &&
                                    _prefs.getBool(
                                            "isResponderLoggedinBefore") ==
                                        true) {
                                  Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(builder: ((context) {
                                    return const HomePage();
                                  })), (route) => false);
                                } else {
                                  AwesomeToaster.showToast(
                                      context: context,
                                      msg:
                                          "You have not logged in as a responder before");
                                }
                              },
                              label: const Text(
                                "EXPLORE OFFLINE",
                                style: TextStyle(color: Colors.blue),
                              ),
                              style: ButtonStyle(
                                  minimumSize: MaterialStateProperty.all(
                                      const Size(double.infinity, 60)),
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.transparent)),
                            ),
                            TextButton(
                                child: const Text("Forgot Password?",
                                    style: TextStyle(color: Colors.grey)),
                                onPressed: () {}),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 400,
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account?  "),
                              TextButton(
                                  child: const Text("Sign Up",
                                      style: TextStyle(color: Colors.blue)),
                                  onPressed: () {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                const SignupPage())),
                                        (route) => false);
                                  }),
                            ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
