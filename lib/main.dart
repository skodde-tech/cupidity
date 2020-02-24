import 'package:flutter/material.dart';
import 'package:speed_dating/appData.dart';
import 'package:speed_dating/pages/home.dart';

// Main function run the app
void main() => runApp(MyApp());

// My App Function
class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      //##############  Name on the app
      title: appName,

      //############## Theme for the app - design
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.dark,
        primaryColor: appYellow,
        accentColor: appBlack,
        backgroundColor: appBlack,

        // Define the default font family.
        fontFamily: 'Georgia',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold, color: appYellow),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic,color: appYellow),
          body1: TextStyle(fontSize: 24.0, fontFamily: 'Hind', color: appBlack),
          body2: TextStyle(fontSize: 24.0, fontFamily: 'Hind', color: appYellow),
        ),


        buttonTheme: ButtonThemeData(
          buttonColor: appBlack,
          padding: EdgeInsets.fromLTRB(30, 5, 30, 5),

        )

        //primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: appName),
    );
  }
}

