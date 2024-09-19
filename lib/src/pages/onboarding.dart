import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrcodegenerator/src/pages/first_qr.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  OnboardingScreenState createState() => OnboardingScreenState();
}

class OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Widget> _pages = [
    const OnboardingPage(
      title: 'Welcome to QR Code App',
      description: 'Easily generate and scan QR codes.',
      imagePath: 'assets/images/splash.png',
    ),
    const OnboardingPage(
      title: 'Text, contacts, and more',
      description: 'Create QR codes for your URLs,\n text, contacts, and more.',
      imagePath: 'assets/images/first.jpg',
    ),
    const OnboardingPage(
      title: 'Scan QR Codes',
      description:
          'Effortlessly Create QR codes with \n embeded icons to access information.',
      imagePath: 'assets/images/embeded.jpg',
    ),
    const OnboardingPage(
      title: 'Get Started!',
      description: 'Start using QR Code Generator App now.',
      imagePath: 'assets/images/second.jpg',
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
                        child: const Text('Get Started'),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _pageController.nextPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.ease);
                            },
                            child: const Text('Next'),
                          ),
                          const SizedBox(width: 10),
                          TextButton(
                            onPressed: () {
                              _finishOnboarding();
                            },
                            child: const Text('Skip'),
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
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.grey,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  void _finishOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('first_time', false);
    Get.to(const FileUploadView());
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
        const SizedBox(height: 50),
        Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
          softWrap: true,
        ),
        const SizedBox(height: 20),
        Image.asset(
          imagePath,
          height: 300,
        ),
        if (!isLastPage) const SizedBox(height: 20),
      ],
    );
  }
}
