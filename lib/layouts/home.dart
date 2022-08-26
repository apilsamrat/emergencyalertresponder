import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergencyalertresponder/layouts/drawer.dart';
import 'package:emergencyalertresponder/layouts/home_allreports.dart';
import 'package:emergencyalertresponder/resources/screen_sizes.dart';
import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';

import '../resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

int caseReported = 0;

String oneSignalAppId = "90c58bbe-a1b6-466e-b0e1-1b3b79563bea";
String notifyUrl = "https://onesignal.com/api/v1/notifications";
String oneSignalapiKey = "NGQyYjFjYTctMDRmMi00MDQ2LTk0ODktNDFlYTRhNmU0ODIz";
String alertMessage =
    "A NEW CASE HAS BEEN REPORTED. PLEASE OPEN THE APP TO VIEW THE DETAILS";

List<String> arrayReportId = [""];
bool hasData = false;
bool isLoading = false;

int _selectedIndex = 0;

String accidentCause = "";
String accidentDescription = "";
Timestamp? emergencyDate;
String emergencyLocation = "";
String emergencyType = "";
bool isSolved = true;
String moreDetails = "";
String reporterContact = "";

PermissionStatus _isLocationPermissionGranted = PermissionStatus.denied;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<bool> _onWillPop() async {
    return (await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Are you sure?"),
              content: const Text("Do you want to exit?"),
              actions: <Widget>[
                TextButton(
                  child: const Text("No"),
                  onPressed: () => Navigator.pop(context, false),
                ),
                TextButton(
                  child: const Text("Yes"),
                  onPressed: () => SystemNavigator.pop(),
                )
              ],
            )));
  }

  locationPermission() async {
    _isLocationPermissionGranted = await Location.instance.hasPermission();
    if (_isLocationPermissionGranted == PermissionStatus.denied) {
      _isLocationPermissionGranted =
          await Location.instance.requestPermission();
    } else if (_isLocationPermissionGranted == PermissionStatus.deniedForever) {
      setState(() {
        showDialog(
            context: context,
            builder: ((context) {
              return AlertDialog(
                actions: [
                  TextButton(
                    child: const Text("Ok"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
                content: const Text(
                    "Please enable location permission in settings to use this app"),
                title: const Text("Location Permission Denied Permanetly"),
              );
            }));
      });
    } else if (_isLocationPermissionGranted == PermissionStatus.granted) {
      return;
    }
  }

  initializeData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('reports')
        .orderBy("accidentDateandTime", descending: true)
        .get();
    setState(() {
      caseReported = querySnapshot.docs.length;

      for (var element in querySnapshot.docs) {
        arrayReportId.add(element.id);
      }
      isLoading = false;
      hasData = true;
    });
  }

  @override
  void initState() {
    super.initState();
    locationPermission();
    initializeData();
    if (!kIsWeb) {
      OneSignal.shared.setAppId(oneSignalAppId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () => _onWillPop(),
        child: Scaffold(
            appBar: AppBar(
              elevation: 0.5,
              title: const Text(
                'Emergency Alert Responder',
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedIndex,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.live_help_rounded),
                  label: "Live Reports",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_box),
                  label: "Saved Reports",
                ),
              ],
              onTap: (index) {
                if (index == 0) {
                  setState(() {
                    _selectedIndex = 0;
                  });
                } else {
                  setState(() {
                    _selectedIndex = 1;
                  });
                }
              },
            ),
            drawer: const DrawerPage(),
            body: Center(
              child: Container(
                width: CreatedSystem(context: context).getIsScreeenWidthBig()
                    ? CreatedSystem(context: context).getPreciseWidth()
                    : CreatedSystem(context: context).getScreenWidth(),
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            child: Card(
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AnimatedFlipCounter(
                                          value: caseReported,
                                          textStyle: TextStyle(
                                              fontFamily: "vt323",
                                              fontSize: 30,
                                              color: lightRed,
                                              fontWeight: FontWeight.bold)),
                                      Text("Cases Reported Yet",
                                          style: TextStyle(
                                            fontFamily: "vt323",
                                            fontSize: 20,
                                            color: lightRed,
                                          )),
                                    ]),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    _selectedIndex == 0
                        ? const AllReports()
                        : const AllReports(), //SavedReports(),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
