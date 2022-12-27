import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class Progress extends StatefulWidget {
  const Progress({Key? key}) : super(key: key);

  @override
  State<Progress> createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: Text("Your Progress", style: TextStyle(fontSize: 21.sp)),
      ),
    );
  }
}
