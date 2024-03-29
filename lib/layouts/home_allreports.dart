import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import 'list_card.dart';

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
                  return listerAllReports(
                      snap: snapshot.data.docs[index],
                      isLiveReport: false,
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
