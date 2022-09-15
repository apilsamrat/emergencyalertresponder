import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergencyalertresponder/layouts/view_reporterprofile.dart';
import 'package:emergencyalertresponder/logics/imagefullview.dart';
import 'package:flutter/material.dart';

import '../resources/colors.dart';

late Map<String, dynamic> data;
Map<String, dynamic> reporterData = {};

class ReportDetails extends StatefulWidget {
  ReportDetails({super.key, fullData}) {
    data = fullData;
  }

  @override
  State<ReportDetails> createState() => _ReportDetailsState();
}

class _ReportDetailsState extends State<ReportDetails> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    await FirebaseFirestore.instance
        .collection("users") //Reporters Data not responders
        .doc(data["userId"])
        .get()
        .then((value) {
      setState(() {
        reporterData = value.data()!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Accident Detailed View")),
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  showImage(context: context, image: data["imageUrl"]);
                },
                child: CachedNetworkImage(
                  imageUrl: data["imageUrl"].toString(),
                  height: 200,
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(data["accidentType"].toString(),
                        style: TextStyle(
                            color: lightRed,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      width: double.infinity,
                      child: Divider(
                        color: lightRed,
                        thickness: 1,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text("Accident severity",
                              style: TextStyle(
                                  color: lightRed,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: Text(data["accidentSeverity"].toString(),
                              style: TextStyle(
                                color: lightRed,
                                fontSize: 15,
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text("Accident Type",
                              style: TextStyle(
                                  color: lightRed,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: Text(data["accidentType"].toString(),
                              style: TextStyle(
                                color: lightRed,
                                fontSize: 15,
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text("Accident Location",
                              style: TextStyle(
                                  color: lightRed,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: Text(data["accidentLocation"].toString(),
                              style: TextStyle(
                                color: lightRed,
                                fontSize: 15,
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text("Accident Date and Time",
                              style: TextStyle(
                                  color: lightRed,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: Text(
                              (data["accidentDateandTime"] as Timestamp)
                                  .toDate()
                                  .toString(),
                              style: TextStyle(
                                color: lightRed,
                                fontSize: 15,
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text("Current Status",
                              style: TextStyle(
                                  color: lightRed,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: Text(data["currentStatus"].toString(),
                              style: TextStyle(
                                color: lightRed,
                                fontSize: 15,
                              )),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text("Reported By",
                              style: TextStyle(
                                  color: lightRed,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(reporterData["fullName"].toString(),
                              style: TextStyle(
                                color: lightRed,
                                fontSize: 15,
                              )),
                        ),
                        Expanded(
                          flex: 1,
                          child: MaterialButton(
                            color: blue,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          ViewReporterProfile(
                                            userId: data["userId"],
                                          ))));
                            },
                            child: Text("View Profile",
                                style: TextStyle(
                                  color: white,
                                  fontSize: 15,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
