import 'package:flutter/cupertino.dart';

import '../layouts/toaster.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../resources/screen_sizes.dart';
import 'login.dart';

bool _isVerifyEnabled = true;
bool _isLoading = false;

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Email Verification Required"),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout_rounded),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Logout"),
                        content: const Text("Are you sure you want to logout?"),
                        actions: [
                          TextButton(
                            child: const Text("No"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: const Text("Yes"),
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                  (route) => false);
                            },
                          ),
                        ],
                      );
                    });
              },
            ),
          ],
        ),
        body: Center(
          child: Container(
            width: CreatedSystem(context: context).getIsScreeenWidthBig()
                ? CreatedSystem(context: context).getPreciseWidth()
                : CreatedSystem(context: context).getScreenWidth(),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(20),
            child: Card(
                child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: const [
                      Text(
                        "Verify your email\n",
                        style: TextStyle(
                            fontFamily: "baloo2",
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ],
                  ),
                  Text(
                    "Hi ${FirebaseAuth.instance.currentUser!.displayName}, Please verify your email address to continue\n",
                    softWrap: true,
                    style: const TextStyle(fontFamily: "vt323", fontSize: 20),
                  ),
                  Visibility(
                    visible: _isVerifyEnabled && !_isLoading,
                    child: TextButton(
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        await FirebaseAuth.instance.currentUser!
                            .sendEmailVerification()
                            .then((value) {
                          setState(() {
                            _isLoading = false;
                            _isVerifyEnabled = !_isVerifyEnabled;
                          });
                        }).catchError((e) {
                          _isLoading = false;
                          AwesomeToaster.showToast(
                              context: context, msg: e.message.toString());
                        });
                      },
                      style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(
                              const Size(double.infinity, 60)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue)),
                      child: const Text(
                        "Verify Email",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _isLoading,
                    child: TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(
                              const Size(double.infinity, 60)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blue)),
                      child: const CupertinoActivityIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !_isVerifyEnabled,
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: () {},
                          style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all(
                                  const Size(double.infinity, 60)),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.grey)),
                          child: const Text(
                            "Verification Email Sent",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Verification Request has been sent at \n${FirebaseAuth.instance.currentUser!.email}",
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontFamily: "vt323", fontSize: 20),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const Text(
                        "Questions?",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text(" Contact us at: "),
                      TextButton(
                          onPressed: () {
                            launchUrlString("mailto:me@apilpoudel.com.np",
                                mode: LaunchMode.externalApplication);
                          },
                          child: const Text("me@apilpoudel.com.np"))
                    ],
                  ),
                ],
              ),
            )),
          ),
        ),
      ),
    ));
  }
}
