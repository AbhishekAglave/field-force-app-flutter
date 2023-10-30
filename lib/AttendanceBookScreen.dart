import 'package:fieldforce/models/Attendance.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceBookScreen extends StatefulWidget {
  @override
  State<AttendanceBookScreen> createState() => _AttendanceBookScreenState();
}

class _AttendanceBookScreenState extends State<AttendanceBookScreen> {
  @override
  void initState() {
    super.initState();
    getAttendance();
  }

  List<Attendance> attendance = [];

  void getAttendance() async {
    var prefs = await SharedPreferences.getInstance();
    List<String> stringAttendance = prefs.getStringList("attendancebook") ?? [];

    setState(() {
      attendance = stringAttendance
          .map((csvString) => Attendance.fromCsvString(csvString))
          .toList();
    });
  }

  void clearAttendanceBook() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.remove("attendancebook");
      getAttendance();
    });
  }

  Text getTitle(DateTime startDateTime) {
    return Text(
        '${DateFormat("EEEE").format(startDateTime)} ${DateFormat("MMM").format(startDateTime)} ${DateFormat("y").format(startDateTime)}');
  }

  Text getSubtitle(DateTime startDateTime, DateTime endDateTime, bool isEnded) {
    if (isEnded) {
      return Text(
          'Start: ${DateFormat("jm").format(startDateTime)} • End: ${DateFormat("jm").format(endDateTime)}');
    }
    return Text(
        'Start: ${DateFormat("jm").format(startDateTime)} • End: -- --');
  }

  Text getTrailing(DateTime startDateTime, DateTime endDateTime, bool isEnded) {
    if (isEnded) {
      return Text(
          '${endDateTime.difference(startDateTime).inHours} hrs ${endDateTime.difference(startDateTime).inMinutes.remainder(60)} min');
    }

    return const Text("-- hrs -- min");
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
            title: getTitle(attendance[index].startDateTime),
            subtitle: getSubtitle(attendance[index].startDateTime,
                attendance[index].endDateTime, attendance[index].isEnded),
            trailing: getTrailing(attendance[index].startDateTime,
                attendance[index].endDateTime, attendance[index].isEnded),
          );
        },
        itemCount: attendance.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => clearAttendanceBook(),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        tooltip: 'Clear Attendance Book',
        child: const Icon(Icons.clear_all_rounded),
      ),
    );
  }
}
