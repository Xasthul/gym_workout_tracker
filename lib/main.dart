import 'package:flutter/material.dart';
import 'package:workout_tracker_prototype/project/app_pages/history.dart';
import 'package:workout_tracker_prototype/project/app_pages/add_workout.dart';
import 'package:workout_tracker_prototype/project/app_pages/progress.dart';
import 'package:workout_tracker_prototype/project/app_pages/loading.dart';
import 'package:animations/animations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:workout_tracker_prototype/project/database/objectbox.dart';

late ObjectBox objectbox;

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  objectbox = await ObjectBox.create();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393.0, 783.0), // 393, 808 | 393, 783
      builder: (BuildContext context, child) => const MaterialApp(
          title: "Gym Workout Tracker",
          debugShowCheckedModeBanner: false,
          home: Home()),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentTabIndex = 1;
  List<Widget> myBody = [
    const AddWorkout(),
    const History(),
    const Progress(),
  ];

  // @override
  // void initState() {
  //   super.initState();
  //   DB.init();
  // };

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> bottomNavBarItems = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(
          icon: Icon(Icons.add_outlined), label: 'Add Workout'),
      const BottomNavigationBarItem(
          icon: Icon(Icons.history_edu_outlined), label: 'History'),
      const BottomNavigationBarItem(
          icon: Icon(Icons.show_chart_outlined), label: 'Progress'),
    ];

    Widget bottomNavBar = BottomNavigationBar(
      iconSize: 27.sp,
      selectedFontSize: 16.sp,
      unselectedFontSize: 14.sp,
      selectedItemColor: Colors.amber[800],
      unselectedItemColor: Colors.black87,
      items: bottomNavBarItems,
      currentIndex: _currentTabIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        setState(() {
          _currentTabIndex = index;
        });
      },
    );
    return Scaffold(
      bottomNavigationBar: bottomNavBar,
      // body: myBody[_currentTabIndex],
      body: Center(
        child: PageTransitionSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
              SharedAxisTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.vertical,
            child: child,
          ),
          child: myBody[_currentTabIndex],
        ),
      ),
    );
  }
}
