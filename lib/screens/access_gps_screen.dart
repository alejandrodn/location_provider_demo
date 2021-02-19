import 'package:flutter/material.dart';
import 'package:maps_app/screens/loading_screen.dart';
import 'package:maps_app/screens/map_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class AccessGpsScreen extends StatefulWidget {
  static final routeName = 'access-gps';

  @override
  _AccessGpsScreenState createState() => _AccessGpsScreenState();
}

class _AccessGpsScreenState extends State<AccessGpsScreen>
    with WidgetsBindingObserver {
  bool popup = false;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed && !popup) {
      if (await Permission.location.isGranted) {
        Navigator.pushReplacementNamed(context, LoadingScreen.routeName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Es necesario el GPS para usar esta app'),
            MaterialButton(
              color: Colors.black,
              onPressed: () async {
                popup = true;
                final status = await Permission.location.request();
                await this.accessGps(status);
                popup = false;
              },
              shape: StadiumBorder(),
              elevation: 0,
              splashColor: Colors.transparent,
              child: Text(
                'Solicitar Acceso',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> accessGps(PermissionStatus status) async {
    switch (status) {
      case PermissionStatus.granted:
        await Navigator.pushReplacementNamed(context, LoadingScreen.routeName);
        break;
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.undetermined:
        openAppSettings();
    }
  }
}
