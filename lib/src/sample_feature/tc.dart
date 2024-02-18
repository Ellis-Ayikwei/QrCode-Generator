import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms and Conditions'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms and Conditions',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Last updated: February 16, 2024',
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Please read these terms and conditions carefully before using Our Service.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Interpretation and Definitions',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Interpretation',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'The words of which the initial letter is capitalized have meanings defined under the following conditions. The following definitions shall have the same meaning regardless of whether they appear in singular or in plural.',
            ),
            SizedBox(height: 8.0),
            Text(
              'Definitions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'For the purposes of these Terms and Conditions:',
            ),
            SizedBox(height: 8.0),
            Text(
              'Application means the software program provided by the Company downloaded by You on any electronic device, named QrCode Generator',
            ),
            Text(
              'Application Store means the digital distribution service operated and developed by Apple Inc. (Apple App Store) or Google Inc. (Google Play Store) in which the Application has been downloaded.',
            ),
            Text(
              'Affiliate means an entity that controls, is controlled by or is under common control with a party, where "control" means ownership of 50% or more of the shares, equity interest or other securities entitled to vote for election of directors or other managing authority.',
            ),
            Text(
              'Country refers to: Ghana',
            ),
            Text(
              'Company (referred to as either "the Company", "We", "Us" or "Our" in this Agreement) refers to QrCode Generator.',
            ),
            Text(
              'Device means any device that can access the Service such as a computer, a cellphone or a digital tablet.',
            ),
            Text(
              'Service refers to the Application.',
            ),
            Text(
              'Terms and Conditions (also referred as "Terms") mean these Terms and Conditions that form the entire agreement between You and the Company regarding the use of the Service. This Terms and Conditions agreement has been created with the help of the Free Terms and Conditions Generator.',
            ),
            Text(
              'Third-party Social Media Service means any services or content (including data, information, products or services) provided by a third-party that may be displayed, included or made available by the Service.',
            ),
            Text(
              'You means the individual accessing or using the Service, or the company, or other legal entity on behalf of which such individual is accessing or using the Service, as applicable.',
            ),
            SizedBox(height: 16.0),
            Text(
              'Acknowledgment',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'These are the Terms and Conditions governing the use of this Service and the agreement that operates between You and the Company. These Terms and Conditions set out the rights and obligations of all users regarding the use of the Service.',
            ),
            SizedBox(height: 8.0),
            Text(
              'Your access to and use of the Service is conditioned on Your acceptance of and compliance with these Terms and Conditions. These Terms and Conditions apply to all visitors, users and others who access or use the Service.',
            ),
            SizedBox(height: 8.0),
            Text(
              'By accessing or using the Service You agree to be bound by these Terms and Conditions. If You disagree with any part of these Terms and Conditions then You may not access the Service.',
            ),
            SizedBox(height: 8.0),
            Text(
              'You represent that you are over the age of 18. The Company does not permit those under 18 to use the Service.',
            ),
            SizedBox(height: 8.0),
            Text(
              'Your access to and use of the Service is also conditioned on Your acceptance of and compliance with the Privacy Policy of the Company. Our Privacy Policy describes Our policies and procedures on the collection, use and disclosure of Your personal information when You use the Application or the Website and tells You about Your privacy rights and how the law protects You. Please read Our Privacy Policy carefully before using Our Service.',
            ),
            SizedBox(height: 16.0),
            // Add more sections of the terms and conditions...
            // You can continue adding Text widgets to display the content
          ],
        ),
      ),
    );
  }
}
