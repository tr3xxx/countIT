import 'dart:io';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: "CounterGame", storage: CounterStorage()),
      theme: ThemeData(
        backgroundColor: Colors.black12
      ),

    );
  }


}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title,required this.storage}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final CounterStorage storage;
  final String title;


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class CounterStorage{
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }
  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$counter');
  }
  Future<File> resetCounter() async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('0');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String path = "assets/images/button1.jpg";

  @override
  void initState() {
    super.initState();

    widget.storage.readCounter().then((value) {
      setState(() {
        _counter = value;
      });
    });

  }


  Future<File> _incrementCounter() {
    setState(() {
      _counter++;
    });

    // Write the variable as a string to the file.
    return widget.storage.writeCounter(_counter);
  }
  Future<File> _reset(){
    setState(() {
      _counter = 0;
    });
    return widget.storage.resetCounter();
  }
  Color _randomColour(){
    return Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
  }



  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold
      (
        body:
           Center(
            child: FractionallySizedBox(
              widthFactor: 1.0,
              heightFactor: 1.0,
              child:
              Container(
                height: MediaQuery. of(context). size. height,
                width:  MediaQuery. of(context). size. width,
                decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage("assets/images/background.jpg"), fit: BoxFit.cover,),
                ),
                  child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[

                          Text(

                            '$_counter',
                            style: const TextStyle
                              (
                              color: Colors.white,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w700,
                              fontSize: 40,
                            ),


                          ),
                        GestureDetector(
                          onTap: (){ Feedback.forTap(context);
                          HapticFeedback.mediumImpact();},
                          onTapCancel: (){
                            path = "assets/images/button1.jpg";
                          },
                          onTapDown: (context){
                            if(path == "assets/images/button1.jpg"){
                              path = "assets/images/button2.jpg";
                            }
                            else{
                              path = "assets/images/button1.jpg";
                            }

                            setState(() {});
                            _incrementCounter();
                          },
                          onTapUp: (context){
                            if(path == "assets/images/button1.jpg"){
                              path = "assets/images/button2.jpg";
                            }
                            else{
                              path = "assets/images/button1.jpg";
                            }
                            setState(() {});
                          },

                          child: Container(
                              child: ClipRRect(
                                  child:  Image.asset(path,width: 250.0, height: 250.0,))),

                        ),


                      ],

                  ),

              ),
            ),
          )
      ,
          ),
      floatingActionButton:
        FloatingActionButton(
          onPressed: (){
            _reset();
          } ,
          child: const Text("Reset"),),

        );
  }
}
