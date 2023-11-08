import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:fieldforce/AttendanceBookScreen.dart';
import 'package:fieldforce/models/Attendance.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';

class AttendanceScreen extends StatefulWidget {
  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  Attendance todaysAttendance =
      Attendance(DateTime.now(), DateTime.now(), 0, 0, true, '');
  bool foundTodaysAttendance = false;
  TextEditingController commentsController = TextEditingController();
  List<Attendance> attendance = [];
  bool showLocationFetchingLoader = true;

  @override
  void initState() {
    super.initState();
    getAttendanceBook();
  }

  getAttendanceBook() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> stringAttendance = prefs.getStringList("attendancebook") ?? [];

    attendance = stringAttendance
        .map((csvString) => Attendance.fromCsvString(csvString))
        .toList();

    getTodaysAttendance(attendance);
  }

  void markAttendance(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    getTodaysAttendance(attendance);

    if (foundTodaysAttendance) {
      todaysAttendance.endDateTime = DateTime.now();
      todaysAttendance.isEnded = true;
      setState(() {
        attendance.removeAt(0);
        attendance.insert(0, todaysAttendance);
        foundTodaysAttendance = false;
      });
      prefs.setStringList("attendancebook",
          attendance.map((attendance) => attendance.toCsvString()).toList());
      getTodaysAttendance(attendance);
      Navigator.pop(context);
      return;
    }

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      pageBuilder: (context, animation1, animation2) {
        return WillPopScope(
          onWillPop: () async {
            // Prevent the dialog from being dismissed by the back button
            return false;
          },
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.blueAccent,
            ), // Your loading indicator here
          ),
        );
      },
    );

    Position position = await _determinePosition();

    Navigator.pop(context);

    void _showToast(BuildContext context, double accuracy) {
      final scaffold = ScaffoldMessenger.of(context);

      scaffold.showSnackBar(
        SnackBar(
          content: Text(
              'Your attendance has been recorded with the accuracy of $accuracy'),
        ),
      );
    }

    void startDay() {
      final newAttendance = Attendance(
          DateTime.now(),
          DateTime.now(),
          position.latitude,
          position.longitude,
          false,
          commentsController.text);

      setState(() {
        attendance.insert(0, newAttendance);
      });

      prefs.setStringList("attendancebook",
          attendance.map((attendance) => attendance.toCsvString()).toList());
      getTodaysAttendance(attendance);
      _showToast(context, position.accuracy);
    }

    if (position.accuracy < 10) {
      startDay();
      Navigator.pop(context);
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext alertContext) {
        return AlertDialog(
          title: const Text("Location Accuracy"),
          content: Text('Your location accuracy is: ${position.accuracy}'),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(alertContext);
                return;
              },
            ),
            TextButton(
              child: const Text("Ok"),
              onPressed: () {
                Navigator.pop(alertContext);
                startDay();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  getTodaysAttendance(List<Attendance> attendance) {
    DateTime today = DateTime.now();
    today = DateTime(today.year, today.month, today.day);

    for (Attendance element in attendance) {
      DateTime elementDate = DateTime(element.startDateTime.year,
          element.startDateTime.month, element.startDateTime.day);
      if (elementDate == today && !element.isEnded) {
        setState(() {
          todaysAttendance = element;
          foundTodaysAttendance = true;
        });
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        scrolledUnderElevation: 0,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        title: const Text(
          'Attendance',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),
        ),
      ),
      body: Center(
        child: Stack(children: [
          Center(
            child: Container(
              width: 220,
              height: 220,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(5, 68, 137, 255),
                  shape: BoxShape.circle),
            ),
          ),
          Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(10, 68, 137, 255),
                  shape: BoxShape.circle),
            ),
          ),
          Center(
            child: Container(
              width: 180,
              height: 180,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(15, 68, 137, 255),
                  shape: BoxShape.circle),
            ),
          ),
          Center(
            child: Container(
              width: 160,
              height: 160,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(20, 68, 137, 255),
                  shape: BoxShape.circle),
            ),
          ),
          Center(
            child: Container(
              width: 140,
              height: 140,
              decoration: const BoxDecoration(
                  color: Colors.blueAccent, shape: BoxShape.circle),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => {
                    showModalBottomSheet(
                      context: context,
                      showDragHandle: true,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return Padding(
                          padding: MediaQuery.of(context).viewInsets,
                          child: SizedBox(
                            height: 220,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.only(bottom: 14),
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.black26,
                                              width: 0.5))),
                                  child: const Text(
                                    'Are you sure?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 14, right: 14),
                                  child: TextField(
                                    controller: commentsController,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.all(14),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.blueAccent),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32))),
                                      labelText: 'Any Comments ( Optional )',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 14, right: 14, bottom: 14),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: const Size.fromHeight(50),
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.blueAccent),
                                    child: Text(foundTodaysAttendance
                                        ? "End My Day"
                                        : "Start My Day"),
                                    onPressed: () => markAttendance(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(70)),
                  child: Center(
                    child: Text(
                      foundTodaysAttendance ? "End" : "Start",
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 28),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          PageTransition(
              child: AttendanceBookScreen(),
              type: PageTransitionType.rightToLeftWithFade),
        ),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        tooltip: 'Attendance Book',
        child: const Icon(Icons.checklist_rounded),
      ),
    );
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
