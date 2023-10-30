import 'package:fieldforce/models/Attendance.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class AttendanceBookScreen extends StatefulWidget {
  @override
  State<AttendanceBookScreen> createState() => _AttendanceBookScreenState();
}

class _AttendanceBookScreenState extends State<AttendanceBookScreen> {
  @override
  void initState() {
    super.initState();
    // getAttendance();
  }

  List<Attendance> attendance = [
    Attendance(
      DateTime.now(),
      DateTime.now().add(const Duration(days: 0, minutes: 5)),
      72.65891,
      45.679846,
    ),
    Attendance(
      DateTime.now().add(const Duration(days: 1)),
      DateTime.now().add(const Duration(days: 1, minutes: 15)),
      72.65891,
      45.679846,
    )
  ];

  // void getAttendance() async {
  //   var prefs = await SharedPreferences.getInstance();
  //   List<String> stringAttendance = prefs.getStringList("attendancebook") ?? [];

  //   setState(() {
  //     attendance = stringAttendance
  //         .map((csvString) => Attendance.fromCsvString(csvString))
  //         .toList();
  //   });
  // }

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
            'Attendance Book',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),
          ),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Text(
                    DateFormat("d").format(attendance[index].startDateTime),
                    style: const TextStyle(color: Colors.white),
                  )),
              title: Text(
                  '${DateFormat("EEEE").format(attendance[index].startDateTime)} ${DateFormat("MMM").format(attendance[index].startDateTime)} ${DateFormat("y").format(attendance[index].startDateTime)}'),
              subtitle: Text(
                  'Start: ${DateFormat("jm").format(attendance[index].startDateTime)} • End: ${DateFormat("jm").format(attendance[index].endDateTime)}'),
              trailing: Text(
                  '${attendance[index].endDateTime.difference(attendance[index].startDateTime).inHours} hrs ${attendance[index].endDateTime.difference(attendance[index].startDateTime).inMinutes.remainder(60)} min'),
            );
          },
          itemCount: attendance.length,
        ));
  }
}
