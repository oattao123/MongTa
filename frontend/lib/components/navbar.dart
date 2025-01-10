import 'package:flutter/material.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:frontend/components/Color/theme.dart';

void main() => runApp(const MyApp());

/// TODO: รอ router เสร็จเดียวลบและแก้ widget นี้ให้หมดทุกหน้า
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, 
      home: BottomNavBar(), 
    );
  }
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {

  // default page = home page (after logged in)
  int _tabIndex = 0;

  // Controller for managing page navigation
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    // Initialize PageController with the starting tab index
    pageController = PageController(initialPage: _tabIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: CircleNavBar(

        // Icons for active tabs
        activeIcons: [
          _buildNavBarIcon('GrayHome', MainTheme.white),
          _buildNavBarIcon('GrayHospital', MainTheme.white),
          _buildNavBarIcon('GrayScan', MainTheme.white),
          _buildNavBarIcon('GrayChat', MainTheme.white),
          _buildNavBarIcon('GraySetting', MainTheme.white),
        ],

        // Icons for inactive tabs
        inactiveIcons: [
          _buildNavBarIcon('GrayHome', MainTheme.navbarText),
          _buildNavBarIcon('GrayHospital', MainTheme.navbarText),
          _buildNavBarIcon('GrayScan', MainTheme.navbarText),
          _buildNavBarIcon('GrayChat', MainTheme.navbarText),
          _buildNavBarIcon('GraySetting', MainTheme.navbarText),
        ],

        height: 60,
        circleWidth: 50,
        // circle background color when active
        circleColor: MainTheme.navbarFocusText,
        // background color when inactive
        color: MainTheme.navbarBackground,

        // label in navbar
        levels: const ["หน้าแรก", "แผนที่", "สแกนตา", "แชท", "การตั้งค่า"],

        // label for active tab
        activeLevelsStyle: const TextStyle(
          fontSize: 10,
          color: MainTheme.navbarFocusText,
          fontFamily: 'BaiJamjuree',
          fontWeight: FontWeight.w500,
          letterSpacing: -0.5,
        ),

        // label for inactive tab
        inactiveLevelsStyle: const TextStyle(
          fontSize: 10,
          color: MainTheme.navbarText,
          fontFamily: 'BaiJamjuree',
          fontWeight: FontWeight.w500,
          letterSpacing: -0.5,
        ),

        cornerRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),

        // drop shadow
        shadowColor: Colors.grey.withOpacity(0.5),
        elevation: 15,

        // animation (in figma: no-animation)
        tabCurve: Curves.decelerate,
        tabDurationMillSec: 0,
        iconDurationMillSec: 0,

        // when change page by navbar
        activeIndex: _tabIndex,
        onTap: (index) {
          setState(() {
            _tabIndex = index;
          });
          pageController.jumpToPage(_tabIndex);
        },
      ),

      // Demo page
      // TODO: router เสร็จเดียวจะมาลบ (อันนี้ไว้ดูคู่กับหน้าจำลองเฉยๆ)
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            _tabIndex = index;
          });
        },
        children: [
          _buildPage("Screen 1", Colors.blue[100]),
          _buildPage("Screen 2", Colors.green[100]),
          _buildPage("Screen 3", Colors.red[100]),
          _buildPage("Screen 4", Colors.yellow[100]),
          _buildPage("Screen 5", Colors.purple[100]),
        ],
      ),
    );
  }

  /// icon in navbar
  Widget _buildNavBarIcon(String assetName, Color color) {
    return Image(
      image: AssetImage('assets/icon/$assetName.png'),
      width: 25,
      height: 25,
      color: color,
    );
  }

  // method for demo page
  // TODO: router เสร็จเดียวจะมาลบ (อันนี้ไว้ดูคู่กับหน้าจำลองเฉยๆ)
  Widget _buildPage(String title, Color? backgroundColor) {
    return Container(
      color: backgroundColor,
      child: Center(
        child: Text(
          title,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
