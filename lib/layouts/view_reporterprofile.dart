import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergencyalertresponder/logics/imagefullview.dart';
import '../resources/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String? name;
String? email;
String? _photoUrl;
String? pp;
String? front;
String? back;
String? documentType;
String? documentNumber;
String? profession;

bool isLoading = true;
late String uid;

class ViewReporterProfile extends StatefulWidget {
  ViewReporterProfile({super.key, required userId}) {
    uid = userId;
  }

  @override
  State<ViewReporterProfile> createState() => _ViewReporterProfileState();
}

class _ViewReporterProfileState extends State<ViewReporterProfile> {
  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    FirebaseFirestore.instance
        .doc("users/$uid/documents/$uid")
        .get()
        .then((value) {
      var data = value.data();
      setState(() {
        pp = data!["pp"];
        front = data["front"];
        back = data["back"];
        documentType = data["documentType"];
        documentNumber = data["documentNumber"];
        profession = data["profession"];
        isLoading = false;
      });
    });
    FirebaseFirestore.instance.doc("users/$uid").get().then((value) {
      var data = value.data();
      setState(() {
        name = data!["fullName"];
        email = data["email"];
        _photoUrl = data["photoUrl"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Reporter's Profile"),
        ),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: (() {
                            showImage(
                                context: context, image: _photoUrl.toString());
                          }),
                          child: CircleAvatar(
                            minRadius: 50,
                            maxRadius: 150,
                            foregroundImage: NetworkImage(_photoUrl.toString()),
                            child: ClipOval(
                              child: CupertinoActivityIndicator(
                                radius: 20,
                                color: white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(name ?? 'Unknown',
                            style: TextStyle(
                              fontSize: 20,
                              color: red,
                              fontWeight: FontWeight.bold,
                            )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(email ?? 'Unknown',
                              style: TextStyle(
                                color: blue,
                                fontSize: 15,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                !isLoading
                    ? Card(
                        elevation: 5,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Column(children: [
                            const Text("Reporter's Legal Profile",
                                style: TextStyle(
                                    fontFamily: "vt323",
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600)),
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                Text("Document Type: $documentType",
                                    style: const TextStyle(
                                      fontFamily: "vt323",
                                      fontSize: 20,
                                    ))
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text("Document Number: $documentNumber",
                                    style: const TextStyle(
                                      fontFamily: "vt323",
                                      fontSize: 20,
                                    ))
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text("Profession: $profession",
                                    style: const TextStyle(
                                      fontFamily: "vt323",
                                      fontSize: 20,
                                    ))
                              ],
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                              child: Row(
                                children: const [
                                  Text("Front of Document:",
                                      style: TextStyle(
                                        fontFamily: "vt323",
                                        fontSize: 20,
                                      ))
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 100,
                              child: InkWell(
                                onTap: () {
                                  showImage(context: context, image: front!);
                                },
                                child: CachedNetworkImage(
                                  imageUrl: front ?? "",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                              child: Row(
                                children: const [
                                  Text("Back of Document:",
                                      style: TextStyle(
                                        fontFamily: "vt323",
                                        fontSize: 20,
                                      ))
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 100,
                              child: InkWell(
                                onTap: () {
                                  showImage(context: context, image: back!);
                                },
                                child: CachedNetworkImage(
                                  imageUrl: back ?? "",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                              child: Row(
                                children: const [
                                  Text("Profile Picture:",
                                      style: TextStyle(
                                        fontFamily: "vt323",
                                        fontSize: 20,
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 100,
                              child: InkWell(
                                onTap: () {
                                  showImage(context: context, image: pp!);
                                },
                                child: CachedNetworkImage(
                                  imageUrl: pp ?? "",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ]),
                        ),
                      )
                    : SizedBox(
                        height: 200,
                        child: CupertinoActivityIndicator(
                          radius: 20,
                          color: blue,
                        ),
                      ),
              ],
            ),
          ),
        ));
  }
}
