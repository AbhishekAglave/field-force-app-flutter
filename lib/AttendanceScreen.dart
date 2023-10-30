import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:fieldforce/AttendanceBookScreen.dart';
import 'package:fieldforce/models/Attendance.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  void markAttendance() async {
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
      return;
    }

    final newAttendance = Attendance(DateTime.now(), DateTime.now(), 72.65891,
        45.679846, false, commentsController.text);

    setState(() {
      attendance.insert(0, newAttendance);
    });

    prefs.setStringList("attendancebook",
        attendance.map((attendance) => attendance.toCsvString()).toList());
    getTodaysAttendance(attendance);
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
                            child: Center(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 8),
                                    child: Text(
                                      'Are you sure?',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: TextField(
                                      controller: commentsController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.blueAccent),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(14))),
                                        labelText: 'Any Comments ( Optional )',
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          minimumSize:
                                              const Size.fromHeight(50),
                                          foregroundColor: Colors.white,
                                          backgroundColor: Colors.blueAccent),
                                      child: Text(foundTodaysAttendance
                                          ? "End My Day"
                                          : "Start My Day"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        markAttendance();
                                      },
                                    ),
                                  ),
                                ],
                              ),
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
                type: PageTransitionType.rightToLeftWithFade)),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        tooltip: 'Attendance Book',
        child: const Icon(Icons.checklist_rounded),
      ),
    );
  }
}
