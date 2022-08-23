// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flushbar/flushbar.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fora_business/views/user-profile-view.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:momentum/momentum.dart';

import '../common/constants.dart';
import '../controllers/auth-controller.dart';

class NavigationBarViewNew extends StatefulWidget {
  const NavigationBarViewNew({Key? key}) : super(key: key);

  @override
  State<NavigationBarViewNew> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBarViewNew>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  void goToSearch() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: 4, initialIndex: 0)
      ..addListener(() {
        setState(() {
          switch (_tabController.index) {
            case 0:
              // some code here
              // Home(callbackSearch: goToSearch);
              break;

            case 1:
              // SearchCategoriesView();
              break;
            // some code here
            case 2:
              // SearchSportsView();
              break;
            case 3:
              // BookingsView();
              break;
          }
        });
      });
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      print('Current connectivity status: $result');
      _tryConnection();
      _tryConnection();
      setState(() {});
    });
  }

  late StreamSubscription _connectivitySubscription;
  bool? _isConnectionSuccessful;

  Future<void> _tryConnection() async {
    try {
      final response = await InternetAddress.lookup('www.google.com');

      setState(() {
        _isConnectionSuccessful = response.isNotEmpty;
      });
    } on SocketException catch (e) {
      print(e);
      setState(() {
        _isConnectionSuccessful = false;
      });
    }
  }

  dispose() {
    super.dispose();
    _tabController.dispose();
    _connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return MomentumBuilder(
        controllers: [AuthController],
        builder: (context, snapshot) {
          return DefaultTabController(
            length: 4,
            child: Scaffold(
              body: GestureDetector(
                onTap: () {
                  if (_isConnectionSuccessful == false) {
                    _tryConnection();
                  }
                },
                child: Stack(
                  children: [
                    TabBarView(
                      controller: _tabController,
                      children: [
                        UserProfile(),
                        UserProfile(),
                        UserProfile(),
                        UserProfile(),
                      ],
                    ),
                    (_isConnectionSuccessful != false)
                        ? SizedBox()
                        : Flushbar(
                            icon: Icon(
                              Icons.error_outline,
                              color: Colors.white,
                              size: 26,
                            ),
                            title: "no internet connection",
                            flushbarPosition: FlushbarPosition.TOP,
                            margin: EdgeInsets.all(8),
                            borderRadius: 8,
                            barBlur: 2,
                            backgroundColor: Color.fromRGBO(247, 54, 54, 0.9),
                            message: "please connect to the internet",
                          ),
                  ],
                ),
              ),
              // getBodyWidget(_selectedIndex),
              // widgetOptions.elementAt(_selectedIndex),
              backgroundColor: Color(0xFFECEFFD),
              bottomNavigationBar: Container(
                height: (69 / 844) * _height,
                width: (337 / 390) * _width,
                margin: EdgeInsets.only(
                    left: (28 / 390) * _width,
                    right: (28 / 390) * _width,
                    bottom: (25 / 844) * _height),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: secondary,
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Color(0xFF18344A),
                      Color(0xFF152532),
                    ],
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  // onTap: (int value) {
                  //   print('Current Index: ${_tabController.index}');
                  //   if (_tabController.index == 3) {

                  //     print('================================');

                  //     print('---------------------------------');

                  //   }
                  // },
                  indicator: BoxDecoration(
                    image: DecorationImage(
                      alignment: Alignment.topCenter,
                      scale: (3.1 / 390) * _width,
                      image: AssetImage("lib/assets/Union-3.png"),
                      // fit: BoxFit.cover,
                    ),
                  ),
                  // UnderlineTabIndicator(
                  //     borderSide: BorderSide(color: primary, width: 4),
                  //     insets: EdgeInsets.fromLTRB(40, 0, 40, 65)),
                  tabs: [
                    Tab(
                        iconMargin: EdgeInsets.all(5),
                        text: 'Analytics',
                        icon: (_tabController.index != 0)
                            ? Icon(Icons.analytics_outlined)
                            : Icon(Icons.analytics_outlined)),
                    Tab(
                      text: 'Calendar',
                      icon: (_tabController.index != 1)
                          ? Icon(
                              Icons.calendar_month_outlined,
                              color: tertiary,
                            )
                          : Icon(
                              Icons.calendar_month_outlined,
                              color: primary,
                            ),
                      iconMargin: EdgeInsets.all((5)),
                    ),
                    Tab(
                      text: 'Bookings',
                      icon: (_tabController.index != 2)
                          ? Image.asset(
                              "lib/assets/Ticket-3.png",
                              height: (24 / 844) * _height,
                              width: (24 / 390) * _width,
                            )
                          : Image.asset(
                              "lib/assets/Vector.png",
                              height: (24 / 844) * _height,
                              width: (24 / 390) * _width,
                            ),
                      iconMargin: const EdgeInsets.all(5),
                    ),
                    Tab(
                      text: 'Profile',
                      icon: (_tabController.index != 3)
                          ? const Icon(
                              Icons.person_outlined,
                              color: tertiary,
                            )
                          : const Icon(
                              Icons.person_outlined,
                              color: primary,
                            ),
                      iconMargin: const EdgeInsets.all((5)),
                    ),
                  ],
                  labelStyle:
                      TextStyle(fontSize: 11.0, fontFamily: 'SfProRounded'),
                  labelColor: primary,
                  unselectedLabelColor: Colors.white,
                  // indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: primary,
                ),
              ),
              // BottomNavigationBar(
              //   landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
              //   backgroundColor: secondary,
              //   unselectedFontSize: 10,
              //   selectedFontSize: 10,
              //   items: <BottomNavigationBarItem>[
              //     BottomNavigationBarItem(
              //       icon: Icon(Icons.home_outlined),
              //       label: 'Home',
              //     ),
              //     BottomNavigationBarItem(
              //       icon: Icon(Icons.search),
              //       label: 'Explore',
              //     ),
              //     BottomNavigationBarItem(
              //       icon: Icon(Icons.book_sharp),
              //       label: 'Bookings',
              //     ),
              //   ],
              //   currentIndex: _selectedIndex,
              //   selectedItemColor: primary,
              //   unselectedItemColor: Colors.white,
              //   onTap: _onItemTapped,
              // ),
            ),
          );
        });
  }
}
