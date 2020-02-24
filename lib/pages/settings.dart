import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speed_dating/objects/settingsObject.dart';
import 'package:speed_dating/storage.dart';

class SettingsPage extends StatefulWidget {
  /// Constructor
  SettingsPage({Key key, this.currentSettings}) : super(key: key);

  // Current settings values.
  final Settings currentSettings;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Settings
  Settings _settings;

  // Storage
  Storage _storage;

  //Initiate the state
  @override
  initState() {
    //Something that need to be their
    super.initState();

    //Set our current index to the one from main
    _settings = widget.currentSettings;

    // Storage object
    _storage = new Storage();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color:Theme.of(context).primaryColor),
              onPressed: () { Navigator.pop(context, _settings); }),
          title: Text("Settings", style: Theme.of(context).textTheme.title),
        ),
        body: settingsInterface(context)
    );
  }

  Widget settingsInterface(BuildContext context){

    return Container(
        decoration: new BoxDecoration(color: Theme.of(context).primaryColor),
        child:Center(
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[


                  /// ACTIVE TIMER
                  Card(
                    color: Theme.of(context).primaryColor,

                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Text("Allow Timer:"),
                          Switch(
                            activeColor: Theme.of(context).accentColor,
                            inactiveThumbColor: Theme.of(context).accentColor,
                            value: _settings.timerActive,
                            onChanged: _onActiveTimeChange,
                          )
                        ],
                      ),
                    ),
                  ),


                  /// Timer value
                  Card(
                    color: Theme.of(context).primaryColor,

                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Text("Timer Value:"),
                          Container(
                            color: Colors.black,
                            child: TextField(
                              keyboardAppearance: Theme.of(context).brightness,
                              keyboardType: TextInputType.number,

                              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.body2,

                              controller: TextEditingController(text: _settings.secondsInTimer.toString()),
                              onChanged: (text) {
                                _settings.secondsInTimer = int.parse(text);

                                _storage.writeSettings(_settings);
                              },
                            ),
                          )

                        ],
                      ),
                    ),
                  ),


                  /// NSFW
                  Card(
                    color: Theme.of(context).primaryColor,

                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Text("Allow NSFW questions:"),
                          Switch(
                            activeColor: Theme.of(context).accentColor,
                            inactiveThumbColor: Theme.of(context).accentColor,
                            value: _settings.nsfwActive,
                            onChanged: _onActiveNSFW,
                          )
                        ],
                      ),
                    ),
                  )


                  ],
            ),
        )
    );
  }

  void _onActiveTimeChange(bool newValue) => setState((){
      _settings.timerActive = newValue;

      _storage.writeSettings(_settings);
  });

  void _onActiveNSFW(bool newValue) => setState((){
    _settings.nsfwActive = newValue;

    _storage.writeSettings(_settings);
  });
}
