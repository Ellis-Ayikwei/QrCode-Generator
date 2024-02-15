import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrcodescanner/src/sample_feature/first_qr.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Widget> _pages = [
    OnboardingPage(
      title: 'Welcome to QR Code App',
      description: 'Easily generate and scan QR codes.',
      imagePath: 'assets/images/flutter_logo.png',
    ),
    OnboardingPage(
      title: 'Add Icons To QR Codes',
      description: 'Create QR codes for your URLs, text, contacts, and more.',
      imagePath: 'assets/images/flutter_logo.png',
    ),
    OnboardingPage(
      title: 'Scan QR Codes',
      description:
          'Effortlessly Create QR codes with embeded icons to access information.',
      imagePath: 'assets/images/flutter_logo.png',
    ),
    OnboardingPage(
      title: 'Get Started!',
      description: 'Start using QR Code Generator App now.',
      imagePath: 'assets/images/flutter_logo.png',
      isLastPage: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (BuildContext context, int index) {
              return _pages[index];
            },
          ),
          Positioned(
            bottom: 80.0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageIndicator(),
            ),
          ),
          Positioned(
            bottom: 20.0,
            right: 0,
            left: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _currentPage == _pages.length - 1
                    ? ElevatedButton(
                        onPressed: () {
                          _finishOnboarding();
                        },
                        child: Text('Get Started'),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _pageController.nextPage(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.ease);
                            },
                            child: Text('Next'),
                          ),
                          SizedBox(width: 10),
                          TextButton(
                            onPressed: () {
                              _finishOnboarding();
                            },
                            child: Text('Skip'),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < _pages.length; i++) {
      indicators.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return indicators;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  void _finishOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('first_time', false);
    Get.to(FileUploadView());
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final bool isLastPage;

  const OnboardingPage({
    Key? key,
    required this.title,
    required this.description,
    required this.imagePath,
    this.isLastPage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 50),
        Text(
          title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 20),
        Image.asset(
          imagePath,
          height: 300,
        ),
        if (!isLastPage) SizedBox(height: 20),
      ],
    );
  }
}
