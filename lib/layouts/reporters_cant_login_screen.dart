import 'package:emergencyalertresponder/resources/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../resources/screen_sizes.dart';
import 'login.dart';

class ReportersCantLogin extends StatefulWidget {
  const ReportersCantLogin({super.key});

  @override
  State<ReportersCantLogin> createState() => _ReportersCantLoginState();
}

class _ReportersCantLoginState extends State<ReportersCantLogin> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Reporters Can't Login as Responder"),
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
                children: [
                  Row(
                    children: [
                      Text(
                        "OOPS!",
                        style: TextStyle(
                            fontFamily: "baloo2",
                            color: black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ],
                  ),
                  Wrap(
                    children: const [
                      Text(
                        "It looks like you have created reporter's account with this email account. Same email account cannot be used as reporter and responder. So if you wish to become a responder, Please create a new account with another email account.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontFamily: "vt323",
                          fontSize: 20,
                        ),
                      ),
                    ],
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
