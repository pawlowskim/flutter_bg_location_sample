import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

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
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bg.Location? location;

  void _initBgGeolocation() {
    //Docs say it should be done each time app starts, no matter of the internal state.
    bg.BackgroundGeolocation.ready(bg.Config(
        desiredAccuracy: bg.Config.DESIRED_ACCURACY_NAVIGATION,
        distanceFilter: 10.0,
        disableLocationAuthorizationAlert: true,
        disableElasticity: true,
        disableStopDetection: true,
        stopOnTerminate: false,
        startOnBoot: true,
        preventSuspend: true,
        stopOnStationary: false,
        pausesLocationUpdatesAutomatically: false,
        heartbeatInterval: 60,
        debug: false,
        reset: true,
        foregroundService: true,
        notification: bg.Notification(
            sticky: true,
            //TODO maybe later can externalize it to single place. It's used in advanced pedometer plugin -> StepsListener.java
            //If we can read from android xml in both places, it would be easier, as in Java file, the notification is loaded first, then updated with this
            // https://stackoverflow.com/questions/55586960/how-do-i-get-android-string-resources-for-flutter-package
            text: "Tracking your steps progress",
            title: "Aglet",
            channelName: "app.aglet.mobile.Pedometer",
            layout: 'notification_layout',
            color: "#${const Color.fromRGBO(144, 19, 254, 1).value.toRadixString(16).padLeft(8, '0')}",
            largeIcon: "mipmap/ic_launcher",
            smallIcon: "mipmap/ic_launcher_notification"
          // strings: {'myCustomElement': 'custom TextBox element'}
        )))
        .then((bg.State state) {
      if (!state.enabled) {
        return bg.BackgroundGeolocation.start();
      }
      return Future.value(state);
    });
    bg.BackgroundGeolocation.onLocation((bg.Location? location) {
      if (mounted) {
        setState(() {
          this.location = location;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: _initBgGeolocation,
              child: const Text(
                'Start tracking',
              ),
            ),
            Text(
              'Current location ${location?.toString(compact: true)}',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }
}
