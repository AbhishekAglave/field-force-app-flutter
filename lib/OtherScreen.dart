import 'package:flutter/material.dart';

class OtherScreen extends StatefulWidget {
  @override
  State<OtherScreen> createState() => _OtherScreen();
}

class _OtherScreen extends State<OtherScreen> {
  @override
  void initState() {
    super.initState();
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
          'Other Screen',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),
        ),
      ),
    );
  }
}
