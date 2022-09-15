import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'list_card.dart';

var before24Hr = Timestamp.now();

class LiveReports extends StatefulWidget {
  const LiveReports({Key? key}) : super(key: key);

  @override
  State<LiveReports> createState() => _LiveReportsState();
}

class _LiveReportsState extends State<LiveReports> {
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
                  return listerAllReports(
                      snap: snapshot.data.docs[index],
                      isLiveReport: true,
                      context: context);
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
