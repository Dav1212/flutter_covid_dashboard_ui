import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_covid_dashboard_ui/config/palette.dart';
import 'package:flutter_covid_dashboard_ui/config/styles.dart';
import 'package:flutter_covid_dashboard_ui/data/data.dart';
import 'package:flutter_covid_dashboard_ui/network/dataStuff.dart';
import 'package:flutter_covid_dashboard_ui/screens/home_screen.dart';
import 'package:flutter_covid_dashboard_ui/widgets/widgets.dart';
import 'package:geolocator/geolocator.dart';

import '../data/data.dart';


class StatsScreen extends StatefulWidget {
  @override
  _StatsScreenState createState() => _StatsScreenState();
  static bool isToday = false;
  static bool isWorld = false;
  static bool isFlipped = false;
}

class _StatsScreenState extends State<StatsScreen> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Position _currentPosition;
  String _currentLocality;
  String _currentPostalCode;
  String _currentCountry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.primaryColor,
     appBar: CustomAppBar(),
      body: CustomScrollView(
        physics: ClampingScrollPhysics(),
        slivers: <Widget>[
          _buildHeader(),
          _buildRegionTabBar(),
          _buildStatsTabBar(),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            sliver: SliverToBoxAdapter(
              child: StatsGrid(),
            ),
          ),
          // Chart
          SliverPadding(
            padding: const EdgeInsets.only(top: 20.0),
            sliver: SliverToBoxAdapter(
              child: CovidBarChart(covidCases: covidUSADailyNewCases),
            ),
          ),
        ],
      ),

    );
  }

  SliverPadding _buildHeader() {
    return SliverPadding(
      padding: const EdgeInsets.all(20.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          'Statistics',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildRegionTabBar() {
    return SliverToBoxAdapter(
      child: DefaultTabController(
        length: (HomeScreen.currentCountry == "USA") ? 3 : 2 ,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          height: 50.0,
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: (HomeScreen.currentCountry == "USA") ? isUSA() : isOtherCountry(),
        ),
      ),
    );
  }

  TabBar isUSA() {
    return TabBar(
            indicator: BubbleTabIndicator(
              tabBarIndicatorSize: TabBarIndicatorSize.tab,
              indicatorHeight: 40.0,
              indicatorColor: Colors.white,
            ),
            labelStyle: Styles.tabTextStyle,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.white,
            tabs: <Widget>[
                Text('Global'),
                Text(HomeScreen.currentCountry), // Automatically uses location to pinpoint the user and show their cases
                Text("State"), // Automatically uses location to pinpoint the user and show their case
            ],
            onTap: (index) {
              if (index == 0) {
                getData();
              } else if (index == 1) {
                print("my country");
              } else {
               
                print("my State");

              }
            },
        );
  }

  TabBar isOtherCountry() {
    return TabBar(
            indicator: BubbleTabIndicator(
              tabBarIndicatorSize: TabBarIndicatorSize.tab,
              indicatorHeight: 40.0,
              indicatorColor: Colors.white,
            ),
            labelStyle: Styles.tabTextStyle,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.white,
            tabs: <Widget>[
                Text('World'),
                Text(HomeScreen.currentCountry), // Automatically uses location to pinpoint the user and show their cases
            ],
            onTap: (index) {
              if (index == 0) {
                setState(() {
                  getGlobalData();
                  StatsScreen.isFlipped = false;
                });
              } else {
                setState(() {
                  StatsScreen.isFlipped = true;
                  getData();
                });
              }
            },
        );
  }
  
  
  SliverPadding _buildStatsTabBar() {
    return SliverPadding(
      padding: const EdgeInsets.all(20.0),
      sliver: SliverToBoxAdapter(
        child: DefaultTabController(
          length: 2,
          child: TabBar(
            indicatorColor: Colors.transparent,
            labelStyle: Styles.tabTextStyle,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            tabs: <Widget>[
              Text('Today'),
              Text('Total'),
            ],
            onTap: (index) {
              if (index == 0)  {
                if (HomeScreen.currentCountry == "World") {
                  setState(() {
                  getGlobalData();
                  StatsScreen.isToday = false;
                  StatsScreen.isWorld = false;
                  getGlobalData();
                });
                }
                else {
                setState(() { // There is a bug right here.
                  getData();
                  StatsScreen.isToday = false;
                  StatsScreen.isWorld = false;
                  getData();
                });
                }
              } else {
                if (HomeScreen.currentCountry == "World") {
                  setState(() {
                  getGlobalData();
                  StatsScreen.isToday = true;
                  StatsScreen.isWorld = true;
                  getGlobalData();
                });
                } else {
                setState(() {
                  getData();
                  StatsScreen.isToday = true;
                  StatsScreen.isWorld = true;
                  getData();
                });
                }
              }
            },
          ),
        ),
      ),
    );
  }

  // Functions that get location

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentLocality = "${place.locality}";
        _currentPostalCode = " ${place.postalCode}";
        _currentCountry = "${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }


  bool isWaiting = false;

  void getData() async {
    isWaiting = true;
    try {
      var data = await Data().getCoronaData(HomeScreen.currentCountry);
      isWaiting = false;

        } catch (e) {
      print(e);
    }
  }

  void getGlobalData() async {
    isWaiting = true;
    try {
      var data = await Data().getCoronaData("World");
      isWaiting = false;

        } catch (e) {
      print(e);
    }
  }
  
}
