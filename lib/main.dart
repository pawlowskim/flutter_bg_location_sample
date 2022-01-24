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
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

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
            text: "Tracking is on",
            title: "My app",
            channelName: "my.app.channel.name",
            layout: 'notification_layout',
            color: "#${const Color.fromRGBO(144, 19, 254, 1).value.toRadixString(16).padLeft(8, '0')}",
            largeIcon: "mipmap/ic_launcher",
            smallIcon: "mipmap/ic_launcher_notification"
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
