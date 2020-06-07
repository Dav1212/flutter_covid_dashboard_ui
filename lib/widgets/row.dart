import 'package:flutter/material.dart';
import 'package:flutter_covid_dashboard_ui/user.dart';

Widget row(User user) {
  
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
     ListView(
       children: <Widget>[
         ListTile(
           title: Text(user.name),
           
         ),
         Padding( 
           padding: EdgeInsets.all(15.0),
         )
       ],
     )
    //   Text(user.name,
    //   style: TextStyle(
    //     fontSize: 16.0,
    //     fontWeight: FontWeight.w500,
    //     color: Colors.black
    //   ),
    // ),
       
    //   Padding(
    //     padding: EdgeInsets.all(15.0),
    //   ),
    ],
  );
}