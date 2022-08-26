import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergencyalertresponder/layouts/report_fullview.dart';
import 'package:emergencyalertresponder/logics/data_view_logic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../resources/colors.dart';

class AllReports extends StatefulWidget {
  const AllReports({Key? key}) : super(key: key);

  @override
  State<AllReports> createState() => _AllReportsState();
}

class _AllReportsState extends State<AllReports> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("reports")
          .orderBy("accidentDateandTime", descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            alignment: Alignment.center,
            child: const CupertinoActivityIndicator(),
          );
        }
        if (snapshot.hasData) {
          return Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: ((context, index) {
                  return lister(
                      snap: snapshot.data.docs[index], context: context);
                })),
          );
        }
        if (!snapshot.hasData) {
          return const Center(child: Text("No Data"));
        }
        return const Center(
          child: CupertinoActivityIndicator(),
        );
      },
    );
  }
}

Widget lister({required snap, required BuildContext context}) {
  var data = snap.data();
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(data["accidentType"],
                    style: TextStyle(
                        color: lightRed,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReportDetails(
                                  fullData: data,
                                )));
                  },
                  child: InkWell(
                    onTap: () {
                      showImage(context: context, data: data);
                    },
                    child: Image.network(
                      data["imageUrl"].toString(),
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
              ],
            ),
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
          ],
        ),
      ),
    ),
  );
}
