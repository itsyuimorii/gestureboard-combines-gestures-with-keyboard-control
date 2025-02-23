import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gesture_board/deserializedData.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const GestureBoardApp());
}

class GestureBoardApp extends StatelessWidget {
  const GestureBoardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        textTheme:
            GoogleFonts.b612MonoTextTheme(), // Apply Google Font globally
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: const GestureBoardHome(),
    );
  }
}

enum AppMode { normal, click, scroll, move }

class GestureBoardHome extends StatefulWidget {
  const GestureBoardHome({super.key});

  @override
  _GestureBoardHomeState createState() => _GestureBoardHomeState();
}

class _GestureBoardHomeState extends State<GestureBoardHome> {
  WebSocketChannel? _channel;
  String _webSocketMessage = "Press 'Start Listening' to connect.";
  bool _isListening = false;
  AppMode _currentMode = AppMode.normal;

  void _toggleWebSocket() {
    if (_isListening) {
      _stopListening();
    } else {
      _startListening();
    }
  }

  void _startListening() {
    setState(() {
      _isListening = true;
      _webSocketMessage = "Connecting...";
    });

    try {
      _channel = IOWebSocketChannel.connect('ws://localhost:8081');
      // print("Message 🚀 $message");

      _channel!.stream.listen(
        (message) {
          List<HandDetection> detections =
              (jsonDecode(message) as List)
                  .map((data) => HandDetection.fromJson(data))
                  .toList();

   
          bool leftClickDetected = detections.any(
            (detection) => detection.gestures.any(
              (gesture) => gesture.name == "OK_SIGN",
            ),
          );

          //Just move mouse, without clicking
          bool moveDetected = detections.any(
            (detection) => detection.gestures.any(
              (gesture) => gesture.name == "U_SIGN",
            ),
           );

          bool scrollDetected = detections.any(
            (detection) => detection.gestures.any(
              (gesture) => gesture.name == "W_SIGN",
            ),
          );

          if (moveDetected) {
            setState(() {
              _currentMode = AppMode.move;
            });
          }

          if (leftClickDetected) {
            setState(() {
              _currentMode = AppMode.click;
            });
          }

          if(scrollDetected){
            setState((){
            _currentMode = AppMode.scroll;
            });
          }

          setState(() {
            _webSocketMessage = "Received: $message";
          });

          print(detections.length);
          // detections.forEach((detection)=> {

          // })

          // // ✅ Perform actions based on message content
          // if (message.contains("OK_SIGN")) {
          //   _performActionOne();
          // } else if (message.contains("ACTION_TWO")) {
          //   _performActionTwo();
          // }
        },
        onError: (error) {
          setState(() {
            _webSocketMessage = "WebSocket Error: $error";
          });
        },
        onDone: () {
          setState(() {
            _webSocketMessage = "Disconnected.";
            _isListening = false;
          });
        },
      );
    } catch (e) {
      setState(() {
        _webSocketMessage = "Failed to connect: $e";
        _isListening = false;
      });
    }
  }

  void _stopListening() {
    if (_channel != null) {
      _channel!.sink.close();
      _channel = null;
    }
    setState(() {
      _isListening = false;
      _webSocketMessage = "Connection closed.";
    });
  }

 

  @override
  void dispose() {
    _stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            children: [
              GestureBoard(currentMode: _currentMode),
              const SizedBox(height: 20),
            ],
          ),

          // ✅ WebSocket message display at the bottom (non-intrusive)
          Positioned(
            left: 50,
            bottom: 80,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _webSocketMessage,
                style: GoogleFonts.b612Mono(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // ✅ Toggle WebSocket Listening Button
          Positioned(
            left: 50,
            bottom: 20,
            child: ElevatedButton(
              onPressed: _toggleWebSocket,
              child: Text(_isListening ? "Stop Listening" : "Start Listening"),
            ),
          ),
        ],
      ),
    );
  }
}

class GestureBoard extends StatelessWidget {
  final AppMode currentMode;
  GestureBoard({required this.currentMode});
  // Function to open a URL
  void _handleClick() async {
    const url = 'https://your-gestureboard-url.com'; // Replace with actual URL
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      debugPrint("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 1728,
          height: 1117,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(color: Colors.white),
          child: Stack(
            children: [
              Positioned(
                left: 127,
                top: 177,
                child: Text(
                  'HAND.',
                  style: GoogleFonts.b612Mono(
                    color: Colors.black,
                    fontSize: 168,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -10.08,
                  ),
                ),
              ),
              Positioned(
                left: 137,
                top: 363,
                child: GestureDetector(
                  onTap: _handleClick, // Make it clickable
                  child: Row(
                    children: [
                      Text(
                        'WHAT GESTURES YOU CAN USE HERE?',
                        style: GoogleFonts.b612Mono(
                          color: Colors.black,
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      Icon(
                        Icons.arrow_right_alt,
                        size: 24,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                left: 137,
                top: 400,
                child: Text(
                  'Current Mode is: ${currentMode.name}',
                  style: GoogleFonts.b612Mono(
                    color: Colors.black,
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // ✅ Original Hand Image
              Positioned(
                left: 840,
                top: 194,
                child: Image.asset(
                  "assets/hand.png",
                  width: 651,
                  height: 923,
                  fit: BoxFit.cover,
                ),
              ),

              // ✅ Corrected Multiply Effect
              Positioned(
                left: 550,
                top: 551,
                child: Image.asset(
                  "assets/hand.png",
                  width: 1178,
                  height: 480,
                  fit: BoxFit.cover,
                  color: const Color(0xFFFF5130),
                  colorBlendMode: BlendMode.multiply,
                ),
              ),

              Positioned(
                left: 137,
                top: 1031,
                child: Transform(
                  transform: Matrix4.identity()..rotateZ(-1.57),
                  child: Text(
                    'GESTUREBOARD + ',
                    style: GoogleFonts.b612Mono(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 695,
                top: 236,
                child: SizedBox(
                  width: 289,
                  child: Text(
                    'は手のジェスチャーとキーボードおよびマウス操作を組み合わせます"',
                    style: GoogleFonts.b612Mono(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 1670,
                top: 194,
                child: SizedBox(
                  width: 230,
                  child: Transform(
                    transform: Matrix4.identity()..rotateZ(1.57),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'COMBINES-GESTURES',
                            style: GoogleFonts.b612Mono(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(
                            text: '-WITH-KEYBOARD AND MOUSE-CONTROL',
                            style: GoogleFonts.b612Mono(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
