
//import 'dart:js';


import 'dart:async';

import 'package:protagonist/exercise.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter/material.dart';
import 'StoryCollection.dart';

class storyPage extends StatefulWidget {
  storyPage({required this.title, required this.chapter});
  String title; //manga title
  int chapter;
  @override
  State<storyPage> createState() => _storyPageState(title: title, chapter: chapter, workouts: exercise[title]![chapter]);
}

class _storyPageState extends State<storyPage> {
 //chapter number
  OverlayEntry? entry;
  int exercise_key=0;
  String title;
  int chapter;
  //which overlay is currently being displayed, to prevent over scrolling to display two overlay one over other
  int turn=0;
  //index of map to access what is the next page that needs to show overlay
  int next_overlay=0;
  //page number and corresponding workout
  Map<int, String> workouts;
  //Has the workout been completed, to not display a exercise once it is completed when you scroll over it again
  Map<int, int>? seen;
  //countDown Time
  int time=5;

  _storyPageState({required this.title, required this.chapter, required this.workouts}){
    seen = Map.fromIterables(workouts.keys, Iterable.generate(workouts.keys.length, (index)=>0));
    turn = workouts.keys.elementAt(next_overlay++);
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: () async {
          final shouldPop = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Exit'),
                content: const Text('Your Progress will be lost, Do you want to quit?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text('Yes'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text(
                      'No',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              );
            },
          );
          return shouldPop!;
        },
      child: ListView.builder(
          itemCount: (story[widget.title]![widget.chapter].length-2),
          itemBuilder: (context, index){
            if(workouts.containsKey(index)){
              return VisibilityDetector(
                  key: Key('${exercise_key++}'),
                  onVisibilityChanged: (VisibilityInfo info) { if(seen!.containsKey(index) && seen![index]==0 && turn==index){showOverlay(index); setState(() {
                    seen![index]=1;
                  });} },
                  child: Image.network(story[widget.title]![widget.chapter][index+1]));
            }
        return Image.network(story[widget.title]![widget.chapter][index+1]);
      }),
    );
  }

  void showOverlay(index){
    entry = OverlayEntry(builder: (context){
      return Container(
        color: Colors.black87,
        child: Column(
            children: [
              Expanded(
                  child: Image.asset('assets/workout_gifs/${workouts[index]}.gif')
              ),
              TimerButton(
                  time: time,
                  exitOverlay:(){
                    entry!.remove();
                    setState(() {
                      if(next_overlay<workouts.keys.length)
                      turn = workouts.keys.elementAt(next_overlay++);
                    });
                  },
              )
            ]
        ),
      );
    });
    final overlay = Overlay.of(context)!;
    overlay.insert(entry!);

  }
}

class TimerButton extends StatefulWidget {
  TimerButton({super.key, required this.time, required this.exitOverlay});
  int time;
  void Function() exitOverlay;
  @override
  State<TimerButton> createState() => _TimerButtonState(time: time, exitOverlay: exitOverlay);
}

class _TimerButtonState extends State<TimerButton> {
  int time;
  int flag=0;
  void Function() exitOverlay;
  _TimerButtonState({required this.time, required this.exitOverlay});
  @override
  Widget build(BuildContext context) {
    if(time>0) {
      if(flag==0){
        flag=1;
        StartCountdown();
      }
      return Text(
        '${time}',
        style: TextStyle(
          color: Colors.white,
          fontSize: 40,
          decoration: TextDecoration.none,
        ),

      );
    } else {
      return ElevatedButton.icon(
          onPressed: (){
            exitOverlay();
          },
          icon: Icon(Icons.play_arrow),
          label: Text('continue'),
        );
    }
  }

  void StartCountdown(){
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        time--;
      });
    });
  }
}




//OverlayBack
//
// ElevatedButton.icon(
// onPressed: (){
// entry!.remove();
// setState(() {
// turn = workouts.keys.elementAt(++next_overlay);
// });
// },
// icon: Icon(Icons.stop_circle_rounded),
// label: Text('Timer'),
// ),


