import 'package:fieldforce/AttendanceScreen.dart';
import 'package:fieldforce/models/User.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Field Force',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade50),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Field Force'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BoxDecoration cardStyle = const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(8)),
      boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black26)]);

  User user =
      User("Abhishek", "Full Stack Developer", "assets/images/profilepic.jpg");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(
                Icons.menu_rounded,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          scrolledUnderElevation: 0,
          backgroundColor: Colors.blueAccent,
          elevation: 0,
          title: Text(
            widget.title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.blueAccent,
                ),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircleAvatar(
                            foregroundImage: AssetImage(user.profilePic)),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.all(2),
                                child: Text(
                                  user.name,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Container(
                                  margin: const EdgeInsets.all(2),
                                  child: Text(
                                    user.designation,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              ListTile(
                title: const Text('Attendance'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      PageTransition(
                          child: AttendanceScreen(),
                          type: PageTransitionType.rightToLeftWithFade));
                },
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              height: 110,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12)),
                  boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black26)]),
              child: Row(
                children: [
                  SizedBox(
                    width: 75,
                    height: 75,
                    child: CircleAvatar(
                        foregroundImage: AssetImage(user.profilePic)),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 18, right: 18),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(2),
                            child: Text(
                              user.name,
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.all(2),
                              child: Text(user.designation))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
                child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              padding: const EdgeInsets.all(18),
              children: [
                InkWell(
                  onTap: () => Navigator.push(
                      context,
                      PageTransition(
                          child: AttendanceScreen(),
                          type: PageTransitionType.rightToLeftWithFade)),
                  child: Container(
                    decoration: cardStyle,
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 40,
                            width: 100,
                            margin: const EdgeInsets.all(8),
                            child: Image.asset(
                              "assets/images/attendance.png",
                              fit: BoxFit.cover,
                            )),
                        const Text(
                          "Attendance",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    )),
                  ),
                ),
                Container(
                  decoration: cardStyle,
                ),
                Container(
                  decoration: cardStyle,
                ),
                Container(
                  decoration: cardStyle,
                ),
                Container(
                  decoration: cardStyle,
                ),
                Container(
                  decoration: cardStyle,
                ),
                Container(
                  decoration: cardStyle,
                ),
                Container(
                  decoration: cardStyle,
                ),
                Container(
                  decoration: cardStyle,
                ),
                Container(
                  decoration: cardStyle,
                ),
                Container(
                  decoration: cardStyle,
                ),
              ],
            ))
          ],
        ));
  }
}
