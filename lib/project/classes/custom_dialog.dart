import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';

void customDialogTextField(BuildContext context, String title, String content,
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
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(50),
                          ],
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

Future<void> customDialogError(BuildContext context, String title,
    String content, String action, Function onAction) async {
  showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r)),
            child: Wrap(
              children: [
                Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.error, size: 40.sp, color: Colors.red[400]),
                      SizedBox(height: 10.h),
                      Text(title, style: TextStyle(fontSize: 18.sp)),
                      Padding(
                        padding: EdgeInsets.only(top: 25.h, bottom: 15.h),
                        child: Text(content, textAlign: TextAlign.center, style: TextStyle(fontSize: 16.sp)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.amber[300]),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel",
                                style: TextStyle(color: Colors.black)),
                          ),
                          SizedBox(width: 10.w),
                          TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.amber[300]),
                            onPressed: () {
                              Navigator.pop(context);
                              onAction();
                            },
                            child: Text(action,
                                style: const TextStyle(color: Colors.black)),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ));
}
