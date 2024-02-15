import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:qrcodescanner/src/sample_feature/first_qr.dart';
import 'package:qrcodescanner/src/sample_feature/pretty_qr.dart';
import 'package:qrcodescanner/src/sample_feature/theme_manager.dart';
import 'package:qrcodescanner/src/settings/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';


// Function to fetch saved images from SharedPreferences
Future<List<String>> getSavedImages() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final keys = prefs.getKeys();
  final savedImages =
      keys.where((key) => key.startsWith('saved_image_')).toList();
  return savedImages.map<String>((key) => prefs.getString(key)!).toList();
}

class updateTheImages extends ChangeNotifier {
  // Getter for the private variable _images
List<String> savedImages = [];

  void removeImage(int index) {
    savedImages.removeAt(index);
    notifyListeners();
  }

  Future<void> initializeImages() async {
    savedImages = await getSavedImages();
    notifyListeners();
  }
}

class FileUploadView extends StatefulWidget {
  const FileUploadView({Key? key}) : super(key: key);

  @override
  _FileUploadViewState createState() => _FileUploadViewState();
}

class _FileUploadViewState extends State<FileUploadView> {
  String? _textInput = null;
  late ThemeManager _themeManager;
  bool isSwitched = false;

  @override
  void initState() {
    super.initState();
    _themeManager = ThemeManager();
  }

  // Method to initialize savedImages list
 

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
          iconTheme: Theme.of(context).appBarTheme.iconTheme,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          title: const Text('QrCode Generator'),
          titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Get.to(SettingsPage());
              },
              icon: const Icon(
                Icons.settings,
                size: 24.0,
              ),
            ),
          ],
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Color.fromARGB(255, 171, 171, 171),
            tabs: [
              Tab(text: 'Create new'),
              Tab(text: 'Saved Images'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // First tab: Upload
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    verticalDirection: VerticalDirection.down,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        height: 300,
                        width: 100,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                                '1. Upload your file to a cloud storage platform like:',
                                style: Theme.of(context).textTheme.bodyLarge),
                            Padding(
                              padding: EdgeInsets.only(left: 16.0),
                              child: Text('- iCloud',
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 16.0),
                              child: Text('- Google Drive',
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 16.0),
                              child: Text(
                                '- Dropbox',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 16.0),
                              child: Text(
                                '- OneDrive',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            Text(
                                '2. Share the file, ensuring access is granted to anyone scanning your code.',
                                style: Theme.of(context).textTheme.bodyLarge),
                            Text('3. Insert the share link below.',
                                style: Theme.of(context).textTheme.bodyLarge)
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            _textInput = value;
                          });
                        },
                        decoration: const InputDecoration(
                          icon: Icon(Icons.link),
                          labelText: 'Enter Text',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: Theme.of(context).elevatedButtonTheme.style,
                        onPressed: () {
                          if (_textInput != null) {
                            Get.to(
                              const PrettyQrHomePage(),
                              arguments: {
                                'textInput': _textInput,
                              },
                            );
                          } else {
                            // Show a Snackbar message if _textInput is empty
                            Get.snackbar(
                              animationDuration: Duration(microseconds: 3000),
                              duration: Duration(milliseconds: 1500),
                              'Input Required',
                              'Please input the link to Generate a Qrcode',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                        child: const Text('Generate QrCode'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Consumer<updateTheImages>(builder: (context, provider, _) {
              List<String> savedImages =
                  context.watch<updateTheImages>().savedImages;
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // Number of columns
                  crossAxisSpacing: 10, // Spacing between columns
                  mainAxisSpacing: 10, // Spacing between rows
                ),
                itemCount: savedImages.length,
                itemBuilder: (context, index) {
                  String imageName = savedImages[index].split('/').last;
                  return GestureDetector(
                    onLongPress: () {
                      showPopupMenu(context, index);
                      print("this is long pressed");
                    },
                    onTap: () {
                      // Handle selection of saved image
                      print('Selected saved image: ${savedImages[index]}');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullImageView(
                            imagePath: savedImages[index],
                            index: index,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      child: Center(
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.file(
                                File(savedImages[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(imageName), // Displaying image name
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            })
          ],
        ),
      ),
    );
  }
}

void showPopupMenu(
  BuildContext context,
  int index,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Options'),
        content: DropdownButton<int>(
          value: 0, // Set default value to 0
          items: [
            DropdownMenuItem<int>(
              value: 0,
              child: Text('Save Image Again'),
            ),
            DropdownMenuItem<int>(
              value: 1,
              child: Text('Delete Image'),
            ),
            DropdownMenuItem<int>(
              value: 2,
              child: Text('Share'),
            ),
          ],
          onChanged: (int? value) {
            if (value != null) {
              // Handle the selected menu item
              if (value == 0) {
                // Save image again
                // print('Save Image Again: ${savedImages[index]}');
              } else if (value == 1) {
                // Delete image
                // print('Delete Image: ${savedImages[index]}');
              } else {
                print('Share');
              }
            }
          },
        ),
      );
    },
  );
}




class FullImageView extends StatelessWidget {
  final String imagePath;
  final int index;

  const FullImageView({Key? key, required this.imagePath, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              showPopupMenu(context, index);
            },
            child: Icon(Icons.menu),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.file(
              File(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
