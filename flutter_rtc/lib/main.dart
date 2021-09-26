import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rtc/firebase_storages.dart';
import 'package:flutter_rtc/models/models.dart';
import 'package:flutter_rtc/signaling.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'user3'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  Signaling? _signaling;
  bool _inCalling = false;
  Session? _session;

  @override
  void initState() {
    super.initState();
    initRenderers();
    _connect();
  }

  initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  void _call() async {
    await _signaling?.callTo('user1', MediaType.Video, false);
  }

  void _connect() async {
    User urs1 = User(id: widget.title);
    FirebaseStorage storage = FirebaseStorage();
    _signaling = Signaling(urs1, storage);

    _signaling?.onSignalingStateChange = (SignalingState state) {
      switch (state) {
        case SignalingState.Closed:
        case SignalingState.Error:
        case SignalingState.Open:
          break;
      }
    };

    _signaling?.onCallStateChange = (Session session, CallState state) {
      switch (state) {
        case CallState.New:
          setState(() {
            _session = session;
            _inCalling = true;
          });
          break;
        case CallState.Leave:
          setState(() {
            _localRenderer.srcObject = null;
            _remoteRenderer.srcObject = null;
            _inCalling = false;
            _session = null;
          });
          break;
        case CallState.Invite:
        case CallState.Connected:
        case CallState.Ringing:
      }
    };

    _signaling?.onLocalStream = ((stream) {
      print("TTTT: onLocalStream");
      _localRenderer.srcObject = stream;
    });

    _signaling?.onAddRemoteStream = ((_, stream) {
      print("TTTT: onAddRemoteStream");
      _remoteRenderer.srcObject = stream;
    });

    _signaling?.onRemoveRemoteStream = ((_, stream) {
      print("TTTT: onRemoveRemoteStream");
      _remoteRenderer.srcObject = null;
    });

    _signaling?.connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:_inCalling ? OrientationBuilder(builder: (context, orientation) {
        return Container(
          child: Stack(children: <Widget>[
            Positioned(
                left: 0.0,
                right: 0.0,
                top: 0.0,
                bottom: 0.0,
                child: Container(
                  margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: RTCVideoView(_remoteRenderer),
                  decoration: BoxDecoration(color: Colors.black54),
                )),
            Positioned(
              left: 20.0,
              top: 20.0,
              child: Container(
                width: orientation == Orientation.portrait ? 90.0 : 120.0,
                height: orientation == Orientation.portrait ? 120.0 : 90.0,
                child: RTCVideoView(_localRenderer, mirror: true),
                decoration: BoxDecoration(color: Colors.black54),
              ),
            ),
          ]),
        );
      }) : Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: _call,
        tooltip: 'Call',
        child: Icon(Icons.call),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
