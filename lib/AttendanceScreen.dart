import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:fieldforce/AttendanceBookScreen.dart';
import 'package:fieldforce/models/Attendance.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class AttendanceScreen extends StatefulWidget {
  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  @override
  void initState() {
    super.initState();
  }

  List<Attendance> attendance = [];

  void markAttendance() async {
    final newAttendance = Attendance(
      DateTime.now(),
      DateTime.now().add(const Duration(days: 0, minutes: 5)),
      72.65891,
      45.679846,
    );

    setState(() {
      attendance.add(newAttendance);
    });

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setStringList("attendancebook",
    //     attendance.map((attendance) => attendance.toCsvString()).toList());
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
      body: InkWell(
        onTap: () => markAttendance(),
        child: Center(
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
              ),
            ),
            const Center(
                child: Text(
              "Start",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 28),
            )),
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context,
            PageTransition(
                child: AttendanceBookScreen(),
                type: PageTransitionType.rightToLeftWithFade)),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        tooltip: 'Attendance Book',
        child: const Icon(Icons.checklist_rounded),
      ),
    );
  }
}
