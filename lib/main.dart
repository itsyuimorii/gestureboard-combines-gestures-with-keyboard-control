import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

class GestureBoardHome extends StatelessWidget {
  const GestureBoardHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ListView(children: [MacbookPro1612()]));
  }
}

class MacbookPro1612 extends StatelessWidget {
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

              // ✅ Clickable Text: "CLICK HERE AND TRY IT →"
              Positioned(
                left: 137,
                top: 363,
                child: GestureDetector(
                  onTap: _handleClick, // Make it clickable
                  child: Row(
                    children: [
                      Text(
                        'CLICK HERE AND TRY IT ',
                        style: GoogleFonts.b612Mono(
                          color: Colors.black,
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                          decoration:
                              TextDecoration.underline, // Optional underline
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
                  color: const Color(0xFFFF5130), // Apply Orange Color
                  colorBlendMode:
                      BlendMode.multiply, // Apply Multiply Blend Mode
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

              Positioned(
                left: 842,
                top: 27,
                child: Text(
                  'Home',
                  style: GoogleFonts.b612Mono(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
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
