import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:speed_dating/objects/settingsObject.dart';
import 'package:speed_dating/widgets/loading.dart';

import 'package:quiver/async.dart';

class QuestionPage extends StatefulWidget {
  /// Constructor
  QuestionPage({Key key, this.questionsFromHome, this.currentSettings}) : super(key: key);

  // List of current questions.
  final List<String> questionsFromHome;
  // Current settings values.
  final Settings currentSettings;

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {

  //Database reference variable
  var db = Firestore.instance;

  // The questions we have again.
  List<String> questions = new List();

  //Random var
  var rng = new Random();
  var rngIndex = 0;

  // Timer var
  int _startTimerValue = 0;
  int _currentTimerValue = 0;
  bool timerActive;
  var timerListener;
  var timerDone = false;


  //Initiate the state
  @override
  initState() {
    //Something that need to be their
    super.initState();

    // if list of questions is 0 in length then it is empty
    if (widget.questionsFromHome.length == 0){

      // If empty load in the questions on new.
      //Firebase get questions
      loadQuestionsFromDB();
    }
    else{
      questions = widget.questionsFromHome;
    }

    //Set if timer is active.
    timerActive = widget.currentSettings.timerActive;

    if (timerActive) {
      // Start the timer.
      startTimer();
    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
              onPressed: () {
                if (timerActive) {
                  cancelTimer(); // Stop timer.
                }
                Navigator.pop(context, widget.questionsFromHome); // Back to home screen
              }),
          title: Text("Questions",style: Theme.of(context).textTheme.title),
          backgroundColor: Theme.of(context).backgroundColor,
        ),
        body: questionInterface(context),
    );
  }

  Widget questionInterface(BuildContext context){
    // When we got the questions from db show a questions
    if (questions.length > 0 ) {
      return Center(
          child: SizedBox.expand(
              child: GestureDetector(
                /// Update
                onTap: changeQuestions,
                child: Card(
                  color: Theme.of(context).primaryColor,

                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[

                          Align(
                              alignment: Alignment.centerRight,
                              child: customTimer(context)
                          ),

                          AutoSizeText(questions[rngIndex], style: Theme.of(context).textTheme.body1,maxLines: 8,),


                      ]
                    )

                )
              )
          )
      );
    }
    // if we got no questions show load screen
    else{
      return customLoading(context);
    }
  }

  void startTimer() {
    print("tes");
    // Set start timer and the current value.
    _startTimerValue = widget.currentSettings.secondsInTimer;
    _currentTimerValue = widget.currentSettings.secondsInTimer;
    timerDone = false;


    // Setup the timer
    var countDownTimer = new CountdownTimer(
      new Duration(seconds: _startTimerValue),
      new Duration(seconds: 1),
    );

    timerListener = countDownTimer.listen(null);
    timerListener.onData((duration) {
      setState(() { _currentTimerValue = _startTimerValue - duration.elapsed.inSeconds; });
    });

    timerListener.onDone(() {
      timerListener.cancel();
      timerDone = true;

    });
  }

  void cancelTimer(){

    timerListener.cancel();

  }

  Widget customTimer(BuildContext context) {
    if (timerActive)
      if (timerDone){
        return RaisedButton(
          onPressed: startTimer,
          child: Text("Restart Timer", style: Theme.of(context).textTheme.body2,),
        );
      }
      else {
        return Text("Timer: $_currentTimerValue", style: Theme.of(context).textTheme.body1,);
      }
    else {
      return Text("");
    }
  }

  void changeQuestions(){

    //Remove question from pool as long it is not a empty line.
    if (questions.length > 0) {
      //Remove question at index
      questions.removeAt(rngIndex);
    }
    // if empty load in the questions again.
    if(questions.length == 0){

      loadQuestionsFromDB();

    }
    else {
      setState(() {
        newRandomNr();
      });
    }
  }

  void loadQuestionsFromDB() {
    // IF - NSFW -- TRUE -- GET ALL QUESTIONS
    if (widget.currentSettings.nsfwActive){
      loadAllQuestionsFromDB();
    }
    //ELSE - GET -- ONLY SAFE QUESTIONS
    else{
      loadSafeQuestionsFromDB();
    }
  }

  void loadAllQuestionsFromDB(){
    db.collection("questions").getDocuments().then((QuerySnapshot snapshot) {

      //List to store the questions
      List<String> qFromDB = new List();

      // Add each question to the list.
      snapshot.documents.forEach((f) => qFromDB.add(f.data["question"]));
      
      // Update the view.
      setState(() {
        questions = qFromDB;
        newRandomNr();
      });
    });
  }

  void loadSafeQuestionsFromDB(){
    db.collection("questions").where("NSFW", isEqualTo: true).getDocuments().then((QuerySnapshot snapshot) {

      //List to store the questions
      List<String> qFromDB = new List();

      // Add each question to the list.
      snapshot.documents.forEach((f) => qFromDB.add(f.data["question"]));

      // Update the view.
      setState(() {
        questions = qFromDB;
        newRandomNr();
      });
    });
  }

  void newRandomNr(){
    // Check if more then 1 question
    if (questions.length > 1) {
      rngIndex = rng.nextInt(questions.length);
    }
    // If 1 or less question
    else {
      rngIndex = 0;
    }
  }

}
