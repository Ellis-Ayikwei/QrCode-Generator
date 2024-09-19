import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qrcodegenerator/src/pages/function.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSupportPage extends StatelessWidget {
  const ContactSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Support'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Need help? We\'re here for you!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Launch Twitter page
                      launchUrl(smsLaunchUri);
                    },
                    icon:
                        const Icon(FontAwesomeIcons.phone, color: Colors.blue),
                    label: const Text(
                      'Phone',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Launch Twitter page
                      launchUrl(smsLaunchUri);
                    },
                    icon: const Icon(FontAwesomeIcons.message,
                        color: Colors.blue),
                    label: const Text(
                      'Sms',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'You can also reach us through:',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8.0,
                runSpacing: 10,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      launchTheUrl("https://facebook.com/tradehut1/");
                    },
                    icon: const Icon(FontAwesomeIcons.facebook,
                        color: Colors.blue),
                    label: const Text(
                      'Facebook',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      launchTheUrl("https://www.instagram.com/tradehut_ghana/");
                    },
                    icon: const Icon(FontAwesomeIcons.instagram,
                        color: Colors.blue),
                    label: const Text(
                      'Instagram',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Launch Twitter page
                      launchUrl(emailLaunchUri);
                    },
                    icon: const Icon(FontAwesomeIcons.twitter,
                        color: Colors.blue),
                    label: const Text(
                      'email',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((MapEntry<String, String> e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}

// ···
final Uri emailLaunchUri = Uri(
  scheme: 'mailto',
  path: 'ellisarmahayikwei@gmail.com',
  query: encodeQueryParameters(<String, String>{
    'subject': 'help from QrCode Generator',
  }),
);

final Uri smsLaunchUri = Uri(
  scheme: 'sms',
  path: '+233 24 813 8722',
  queryParameters: <String, String>{
    'body': 'Hi, I have a problem with the qrcode app',
  },
);

final Uri phoneLaunchUri = Uri(
  scheme: 'tel',
  path: '+233 24 813 8722',
);
