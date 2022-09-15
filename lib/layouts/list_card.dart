import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../logics/imagefullview.dart';
import '../resources/colors.dart';
import 'report_fullview.dart';

bool _return = false;

Widget listerAllReports(
    {required snap, required isLiveReport, required BuildContext context}) {
  var data = snap.data();

  if (isLiveReport) {
    if (DateTime.now()
            .difference((data["accidentDateandTime"] as Timestamp).toDate())
            .inHours <=
        24) {
      _return = true;
    } else {
      _return = false;
    }
  } else {
    _return = true;
  }
  if (_return) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ReportDetails(
                      fullData: data,
                    )));
      },
      child: Card(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Row(
                                  children: const [
                                    Text(
                                      "Accident Type:",
                                      style: TextStyle(
                                        fontFamily: "vt323",
                                        fontSize: 17,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(data["accidentType"],
                                          style: TextStyle(
                                              color: lightRed,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Row(
                                  children: const [
                                    Text(
                                      "Accident Severity:",
                                      style: TextStyle(
                                        fontFamily: "vt323",
                                        fontSize: 17,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(data["accidentSeverity"],
                                          style: TextStyle(
                                              color: lightRed,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(blue),
                              ),
                              onPressed: (() {
                                launchUrlString(
                                    data["accidentLocation"].toString(),
                                    mode: LaunchMode.platformDefault,
                                    webOnlyWindowName: "Accident Location");
                              }),
                              child: Text(
                                "Visit Location",
                                style: TextStyle(color: white),
                              )),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            showImage(
                                context: context, image: data["imageUrl"]);
                          },
                          child: CachedNetworkImage(
                            imageUrl: data["imageUrl"].toString(),
                            width: 100,
                            height: 100,
                          ),
                        ),
                        SizedBox(
                          child: DateTime.now()
                                      .difference((data["accidentDateandTime"]
                                              as Timestamp)
                                          .toDate())
                                      .inHours <=
                                  0
                              ? DateTime.now()
                                          .difference(
                                              (data["accidentDateandTime"]
                                                      as Timestamp)
                                                  .toDate())
                                          .inMinutes <=
                                      0
                                  ? Text(
                                      "${DateTime.now().difference((data["accidentDateandTime"] as Timestamp).toDate()).inSeconds} Seconds Ago",
                                      style: TextStyle(color: red),
                                    )
                                  : Text(
                                      "${DateTime.now().difference((data["accidentDateandTime"] as Timestamp).toDate()).inMinutes} Minutes Ago",
                                      style: TextStyle(color: red),
                                    )
                              : DateTime.now()
                                          .difference(
                                              (data["accidentDateandTime"]
                                                      as Timestamp)
                                                  .toDate())
                                          .inHours >
                                      24
                                  ? Text(
                                      "${DateTime.now().difference((data["accidentDateandTime"] as Timestamp).toDate()).inDays} Days Ago",
                                      style: TextStyle(color: red),
                                    )
                                  : Text(
                                      "${DateTime.now().difference((data["accidentDateandTime"] as Timestamp).toDate()).inHours} Hours Ago",
                                      style: TextStyle(color: red),
                                    ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // SizedBox(
              //   width: double.infinity,
              //   child: Divider(
              //     color: lightRed,
              //     thickness: 1,
              //   ),
              // ),
              // const SizedBox(
              //   height: 5,
              // ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: Text("Accident severity",
              //           style: TextStyle(
              //               color: lightRed,
              //               fontSize: 15,
              //               fontWeight: FontWeight.bold)),
              //     ),
              //     Expanded(
              //       child: Text(data["accidentSeverity"].toString(),
              //           style: TextStyle(
              //             color: lightRed,
              //             fontSize: 15,
              //           )),
              //     ),
              //   ],
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: Text("Accident Type",
              //           style: TextStyle(
              //               color: lightRed,
              //               fontSize: 15,
              //               fontWeight: FontWeight.bold)),
              //     ),
              //     Expanded(
              //       child: Text(data["accidentType"].toString(),
              //           style: TextStyle(
              //             color: lightRed,
              //             fontSize: 15,
              //           )),
              //     ),
              //   ],
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: Text("Accident Location",
              //           style: TextStyle(
              //               color: lightRed,
              //               fontSize: 15,
              //               fontWeight: FontWeight.bold)),
              //     ),
              //     Expanded(
              //       child: Text(data["accidentLocation"].toString(),
              //           style: TextStyle(
              //             color: lightRed,
              //             fontSize: 15,
              //           )),
              //     ),
              //   ],
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: Text("Accident Date and Time",
              //           style: TextStyle(
              //               color: lightRed,
              //               fontSize: 15,
              //               fontWeight: FontWeight.bold)),
              //     ),
              //     Expanded(
              //       child: Text(
              //           (data["accidentDateandTime"] as Timestamp)
              //               .toDate()
              //               .toString(),
              //           style: TextStyle(
              //             color: lightRed,
              //             fontSize: 15,
              //           )),
              //     ),
              //   ],
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: Text("Current Status",
              //           style: TextStyle(
              //               color: lightRed,
              //               fontSize: 15,
              //               fontWeight: FontWeight.bold)),
              //     ),
              //     Expanded(
              //       child: Text(data["currentStatus"].toString(),
              //           style: TextStyle(
              //             color: lightRed,
              //             fontSize: 15,
              //           )),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  } else {
    return const SizedBox();
  }
}
