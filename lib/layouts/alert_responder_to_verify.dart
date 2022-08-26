import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergencyalertresponder/layouts/verify_responder.dart';
import 'package:emergencyalertresponder/resources/colors.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../resources/screen_sizes.dart';
import 'login.dart';

bool _isVerifyEnabled = true;
bool _isVerificationRequestSent = false;
bool _isLoading = true;
String title = "Verify Your Identity";
String text1 =
    "Hi ${FirebaseAuth.instance.currentUser!.displayName}, Please verify your identity as a responder or authorized personnal to continue.\n";

class AlertResponderToVerify extends StatefulWidget {
  const AlertResponderToVerify({super.key});

  @override
  State<AlertResponderToVerify> createState() => _AlertResponderToVerifyState();
}

class _AlertResponderToVerifyState extends State<AlertResponderToVerify> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    await FirebaseFirestore.instance
        .doc("responders/${FirebaseAuth.instance.currentUser!.uid}")
        .get()
        .then((value) {
      Map<String, dynamic>? data = value.data();
      setState(() {
        _isVerificationRequestSent =
            data?["isVerificationRequestSent"] ?? false;
        _isLoading = false;
        if (_isVerificationRequestSent) {
          title = "Verification Request Received\n";
          text1 =
              "We have received your verification request. Please wait for about two business days to get verified!\n\n";
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Responder's Verification Required"),
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
          child: _isLoading
              ? const CupertinoActivityIndicator()
              : Container(
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
                              title,
                              style: TextStyle(
                                  fontFamily: "baloo2",
                                  color: black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ],
                        ),
                        Wrap(
                          children: [
                            Text(
                              text1,
                              style: TextStyle(
                                fontFamily: "vt323",
                                fontSize: 20,
                                color:
                                    _isVerificationRequestSent ? blue : black,
                              ),
                            ),
                            !_isVerificationRequestSent
                                ? Text(
                                    "Please submit your legal documents in the next screen to be verified.\n",
                                    softWrap: true,
                                    style: TextStyle(
                                        fontFamily: "vt323",
                                        color: red,
                                        fontSize: 20),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                        Visibility(
                          visible: _isVerifyEnabled,
                          child: TextButton(
                            onPressed: () {
                              Future.delayed(const Duration(milliseconds: 50),
                                  () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) =>
                                            const VerifyResponder())));
                              });
                            },
                            style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(
                                    const Size(double.infinity, 60)),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.blue)),
                            child: const Text(
                              "Proceed to Legal Verification",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
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
