import 'package:flutter/material.dart';

import '../screens/screens.dart';

class CountryDropdown extends StatelessWidget {
  // Code here to change countries drop down
  final List<String> countries;
  final String country;
  final Function(String) onChanged;

  const CountryDropdown({
    @required this.countries,
    @required this.country,
    @required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      height: 40.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 12.0,
                          child: Image.asset(
                            'assets/images/${"usa"}_flag.png',
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          HomeScreen.currentCountry,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
      // child: DropdownButtonHideUnderline(
      //   child: DropdownButton<String>(
      //     value: country,
      //     items: countries
      //         .map((e) => DropdownMenuItem(
      //               child: Row(
      //                 children: <Widget>[
      //                   CircleAvatar(
      //                     radius: 12.0,
      //                     child: Image.asset(
      //                       'assets/images/${e.toLowerCase()}_flag.png',
      //                     ),
      //                   ),
      //                   const SizedBox(width: 8.0),
      //                   Text(
      //                     e,
      //                     style: const TextStyle(
      //                       fontSize: 16.0,
      //                       fontWeight: FontWeight.bold,
      //                     ),
      //                   )
      //                 ],
      //               ),
      //               value: e,
      //             ))
      //         .toList(),
      //     onChanged: onChanged,
      //   ),
      // ),
    );
  }
}
