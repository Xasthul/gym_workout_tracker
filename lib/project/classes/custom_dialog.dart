import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void customDialog(BuildContext context, String title, String content,
    TextEditingController controller, String action, Function onAction) {
  showDialog<String>(
      context: context,
      builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r)),
            child: Wrap(
              children: [
                Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(title, style: TextStyle(fontSize: 18.sp)),
                      Padding(
                        padding: EdgeInsets.only(top: 25.h, bottom: 15.h),
                        child: TextField(
                          autofocus: true,
                          controller: controller,
                          decoration: InputDecoration(
                              hintText: content,
                              contentPadding: EdgeInsets.all(10.w),
                              isDense: true,
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.r)))),
                          onSubmitted: (_) {
                            onAction();
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.amber[300]),
                        onPressed: () {
                          onAction();
                          Navigator.of(context).pop();
                        },
                        child: Text(action,
                            style: const TextStyle(color: Colors.black)),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ));
}
