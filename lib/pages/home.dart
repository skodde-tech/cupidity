import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speed_dating/objects/homeObject.dart';
import 'package:speed_dating/objects/settingsObject.dart';
import 'package:speed_dating/pages/questions.dart';
import 'package:speed_dating/pages/settings.dart';
import 'package:speed_dating/storage.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  /// Home object to store the values. 
  Home _home;

  /// Storage
  Storage _storage;
  
  /// Initiate the state
  @override
  initState() {
      // Something that need to be their
      super.initState();
      
      // Setup the home object
      _home = new Home();
      _storage = new Storage();

      _storage.readSettings().then((onValue) => _home.settings = onValue);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: homeInterface(context)
    );
  }
  
  Widget homeInterface(BuildContext context){

      return Container(
          decoration: new BoxDecoration(color: Theme.of(context).primaryColor),
          child:Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                /// QUESTIONS
                RaisedButton(

                  //Function on button
                  onPressed: () => _navigateToQuestionPage(context, _home.settings, _home.questions)
                      .then((onValue) => _home.questions = onValue),

                  //Title
                  child: Text("Start", style: Theme.of(context).textTheme.title),

                ),

                SizedBox(height: 5),

                /// SETTINGS
                RaisedButton(

                  //Function on button
                  onPressed: () => _navigateToSettingsPage(context, _home.settings),

                  //Title
                  child: Text("Settings",style: Theme.of(context).textTheme.title),

                ),

                SizedBox(height: 5),

                /// EXIT
                RaisedButton(

                  //Function on button
                  onPressed: () => SystemChannels.platform.invokeMethod('SystemNavigator.pop'),

                  //Title
                  child: Text("Exit", style: Theme.of(context).textTheme.title),

                ),
            ],
          ),
        )
      );
  }

  ///
  /// It navigates to the setting page
  /// @param context for how it will building.
  ///
  Future<Settings> _navigateToSettingsPage(BuildContext context, Settings settings) async{
    //Navigate to the settings page
    Settings newSettings = await Navigator.push(
      //The build context we have
        context,

        // Create the SelectionScreen in the next step.
        MaterialPageRoute(builder: (context) => SettingsPage(currentSettings: settings,))
    );

    return newSettings;
  }

  ///
  /// It navigates to the question page
  /// @param context for how it will building.
  ///
  Future<List<String>> _navigateToQuestionPage(BuildContext context, Settings settings, List<String> questions) async{
    //Navigate to the settings page
    List<String> currentListOfQuesitons = await Navigator.push(
      //The build context we have
        context,

        // Create the SelectionScreen in the next step.
        MaterialPageRoute(builder: (context) => QuestionPage(currentSettings: settings, questionsFromHome: questions,))
    );

    return currentListOfQuesitons;
  }

}
