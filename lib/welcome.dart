import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:citizen_eye/camera_app.dart';

/// This class represents the welcome screen of the app.
/// It is a stateful widget that displays a series of pages with images, titles, and content.
/// The user can navigate through the pages using the "Back" and "Next" buttons.
/// When the user reaches the last page, they can continue to the next screen.
class WelcomeScreen extends StatefulWidget {
  final CameraDescription firstCamera;

  /// Constructs a new instance of the [WelcomeScreen] class.
  /// The [firstCamera] parameter is required and represents the camera description.
  const WelcomeScreen({super.key, required this.firstCamera});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

/// This class represents the state of the [WelcomeScreen].
class _WelcomeScreenState extends State<WelcomeScreen> {
  final controller = PageController();
  final pages = [
    'assets/images/image.jpg',
    'assets/images/image.jpg',
    'assets/images/image.jpg',
    // Add more image paths as needed
  ];
  final content = [
    "This is a development version of the app, please be aware that some features may not work as expected. Feedback is appreciated!",
    "Please do not interact with this app while driving. \n This app is designed to be used by a passenger, or while the vehicle is stationary.",
    "By using this app, you agree to the terms and conditions. \n Please read the terms and conditions before using the app. \n Thank you!",
  ];
  final bodyTitle = [
    "Welcome to Citizen's Eye",
    "Safety",
    "Terms and Conditions",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Citizen\'s Eye', style: TextStyle(color: Colors.black))
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: PageView.builder(
              controller: controller,
              itemCount: pages.length,
              itemBuilder: (context, index) {
                return Center(
                  child: Column(
                    children: <Widget>[
                      Image.asset(pages[index], fit: BoxFit.cover, width: 1000),
                      Text(bodyTitle[index],
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(content[index], textAlign: TextAlign.center),
                    ],
                  ),
                );
              },
            ),
          ),
          AnimatedBuilder(
            animation: controller,
            builder: (context, snapshot) {
              return ButtonBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (controller.hasClients &&
                      controller.page != null &&
                      controller.page! > 0)
                    ElevatedButton(
                      onPressed: () {
                        controller.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease);
                      },
                      child: const Text('Back'),
                    ),
                  ElevatedButton(
                    onPressed: () {
                      if (controller.hasClients &&
                          controller.page != null &&
                          controller.page! < pages.length - 1) {
                        controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease);
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CameraApp(camera: widget.firstCamera)),
                        );
                      }
                    },
                    child: Text(controller.hasClients &&
                            controller.page != null &&
                            controller.page! < pages.length - 1
                        ? 'Next'
                        : 'Continue'),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
