import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomToast extends StatelessWidget {
  final String message;
  final Color color;

  const CustomToast(this.message, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.r),
        color: color,
      ),
      child: Text(message, style: TextStyle(fontSize: 16.sp)),
    );
  }
}

void customToast(BuildContext context, String message, Color color) {
  var fToast = FToast();
  fToast.init(context);
  fToast.showToast(
    child: CustomToast(message, color),
    gravity: ToastGravity.TOP,
    toastDuration: const Duration(seconds: 2),
  );
}
