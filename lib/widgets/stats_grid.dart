import 'package:flutter/material.dart';
import 'package:flutter_covid_dashboard_ui/network/dataStuff.dart';
import 'package:flutter_covid_dashboard_ui/screens/home_screen.dart';
import 'package:flutter_covid_dashboard_ui/screens/screens.dart';
import 'package:flutter_covid_dashboard_ui/widgets/worldData.dart';
import 'package:number_display/number_display.dart';


// get the name of the country then get the covidnumbers then put it in
class StatsGrid extends StatefulWidget {
  // stats placed here
  @override
  _StatsGridState createState() => _StatsGridState();
}

class _StatsGridState extends State<StatsGrid> {
  StatsScreen statsScreen = new StatsScreen();

  final controller = ScrollController();
  double offset = 0;
  int total = 0;
  final display = createDisplay(length: 4);
  TextEditingController emailController = new TextEditingController();

  String confirmed;
  String death;
  String recover;
  String active;
  String critical;

  String worldCases;
  String worldDeaths;
  String worldRecover;
  String worldActive;
  String worldCritical;

  String worldTodayCases;
  String worldTodayDeaths;



   

  bool isWaiting = false;

  void getData() async {
    isWaiting = true;
    try {
      var data = await Data().getCoronaData(HomeScreen.currentCountry);
      isWaiting = false;
      setState(() {
        confirmed = Data.totalConfirm;
        death = Data.totalDeath;
        recover = Data.totalRecover;

        active = Data.totalActive;
        critical = Data.totalCritical;
      });
    } catch (e) {
      print(e);
    }
  }

  void getWorldData() async {
    isWaiting = true;
    try {
      var data = await WorldData().getCoronaWorldData("World");
      isWaiting = false;
      setState(() {
        worldCases = WorldData.totalConfirm;
        worldDeaths = WorldData.totalDeath;
        worldRecover = WorldData.totalRecover;
        worldActive = WorldData.totalActive;
        worldCritical = WorldData.totalCritical;

        worldTodayCases = WorldData.totalTodayCases;
        worldTodayDeaths = WorldData.totalTodayDeaths;
      });
    } catch (e) {
      print(e);
    }
  }
  

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(onScroll);
    getData();
    getWorldData();
    confirmed = Data.totalConfirm;
    death = Data.totalDeath;
    recover = Data.totalRecover;
    active = Data.totalActive;
    critical = Data.totalCritical;
    getData();
    getWorldData();
    print(WorldData.totalConfirm);

    
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return StatsScreen.isToday ? 
       StatsScreen.isFlipped ?   
       // runs if the user wants the Today Data and the target is World
       totalNumber(Data.totalConfirm, Data.totalDeath, Data.totalRecover, Data.totalActive, Data.totalCritical) // fix recover, active, critical
       // runs if the user wants Today Data and the target is other countries
       : totalNumber(worldCases, worldDeaths, worldRecover , worldActive, worldCritical)
       // runs if the user wants the total numbers Data and the target is World
       : StatsScreen.isFlipped ? todayTotalNumber(Data.totalTodayCases, Data.totalTodayDeaths, Data.totalRecover, Data.totalActive, Data.totalCritical)
      // runs if the user wants the total numbers Data and the target is other countries
       : todayTotalNumber(worldTodayCases, worldTodayDeaths, worldRecover , worldActive, worldCritical); // fix recover, active, critical
        
  }

  Container totalNumber(String totalConfirm, String totalDeath, String totalRecover, String totalActive, String totalCritical) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25, //  .25
      child: Column(
        children: <Widget>[
          Flexible(
            child: Row(
              children: <Widget>[
                _buildStatCard('Total Cases', totalConfirm, Colors.orange),
                _buildStatCard('Deaths', totalDeath, Colors.red),
              ],
            ),
          ),
          Flexible(
            child: Row(
              children: <Widget>[
                _buildStatCard('Recovered', totalRecover, Colors.green),
                _buildStatCard('Active', totalActive, Colors.lightBlue),
                _buildStatCard('Critical', totalCritical, Colors.purple),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container todayTotalNumber(String totalConfirm, String totalDeath, String totalRecover, String totalActive, String totalCritical) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      child: Column(
        children: <Widget>[
          Flexible(
            child: Row(
              children: <Widget>[
                _buildStatCard('Total Cases', totalConfirm, Colors.orange),
                _buildStatCard('Deaths', totalDeath, Colors.red),
              ],
            ),
          ),
          Flexible(
            child: Row(
              children: <Widget>[
                _buildStatCard('Recovered', "Not finished", Colors.green),
                _buildStatCard('Active',"Not finished", Colors.lightBlue),
                _buildStatCard('Critical', "Not finished", Colors.purple),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Expanded _buildStatCard(String title, String count, MaterialColor color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              count,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
