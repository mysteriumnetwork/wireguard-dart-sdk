import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wireguard_dart/wireguard_dart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _wireguardDartPlugin = WireguardDart();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = '';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      debugPrint(_platformVersion);
    });

    _wireguardDartPlugin.setupTunnel(bundleId: "com.example.wireguardDartExample.WireguardExtension");
  }

  @override
  Widget build(BuildContext context) {
    const wireguardConfig = """
    [Interface]
      PrivateKey = CD+RJ5YOaff004qq4BZCAx1QwD07qOKxJ9zSaTs/Olc=
      Address = 172.21.123.5/32
      DNS = 172.21.123.1
    [Peer]
      PublicKey = xo72tCDvCDjMxNZJ4buAWOlfhI0L4fPIxhcvpZwc/hs=
      AllowedIPs = 0.0.0.0/0
      Endpoint = 157.90.228.151:26611
      PersistentKeepalive = 15
    """;
    void handleConnectPressed() => {_wireguardDartPlugin.connect(cfg: wireguardConfig)};
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
          constraints: const BoxConstraints.expand(),
          padding: const EdgeInsets.all(16),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("dududu"),
                TextButton(
                    onPressed: handleConnectPressed,
                    style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all<Size>(const Size(100, 50)),
                        padding: MaterialStateProperty.all(const EdgeInsets.fromLTRB(20, 15, 20, 15)),
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
                        overlayColor: MaterialStateProperty.all<Color>(Colors.white.withOpacity(0.1))),
                    child: const Text(
                      'Connect',
                      style: TextStyle(color: Colors.white),
                    ))
              ]),
        ),
      ),
    );
  }
}
