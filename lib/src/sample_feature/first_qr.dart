import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:qrcodescanner/src/sample_feature/fullImageView.dart';
import 'package:qrcodescanner/src/sample_feature/pretty_qr.dart';
import 'package:qrcodescanner/src/settings/settings_page.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Function to fetch saved images from SharedPreferences
Future<List<String>> getSavedImages() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final keys = prefs.getKeys();
  final savedImages =
      keys.where((key) => key.startsWith('saved_image_')).toList();

  final jogtest =
      savedImages.map<String>((key) => prefs.getString(key)!).toList();
  print("jog:$jogtest");
  return jogtest;
}

Future<void> deleteImageFromPrefs(String key) async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
    print('Successfully removed key: $key from SharedPreferences');
  } catch (e) {
    print('Error deleting key $key from SharedPreferences: $e');
    // Handle the error here, such as showing an error message to the user
  }
}

class updateTheImages extends ChangeNotifier {
  // Getter for the private variable _images
  List<String> savedImages = [];
  List<String> items = [];
  Future<void> removeImage(int index) async {
    // Extract the key from the image path
    final path = await getTemporaryDirectory();
    String imagePath = savedImages[index];
    String key = imagePath.split('/').last.replaceAll('.png', '');

    // Remove the entry from SharedPreferences
    await deleteImageFromPrefs(key);

    // Remove the image path from the list
    savedImages.removeAt(index);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await deleteImageFile(imagePath);
    items = prefs.getKeys().toList();
    notifyListeners();
    print("$key was deleted. Remaining items are: $items and the path $path");
  }

  Future<void> shareQrCode(int index) async {
    String imagePath = savedImages[index];

    try {
      if (imagePath != null) {
        // Share the temporary file
        await Share.shareXFiles([XFile('${imagePath}')], text: 'Great picture');

        // Delete the temporary file after sharing
      } else {
        print('Error: Unable to share QR code');
      }
    } catch (e) {
      print('Error sharing QR code: $e');
    }
  }

  Future<void> deleteImageFile(String imagePath) async {
    try {
      final File imageFile = File(imagePath);
      if (await imageFile.exists()) {
        await imageFile.delete();
        print('Image file deleted: $imagePath');
      } else {
        print('Image file not found: $imagePath');
      }
    } catch (e) {
      print('Error deleting image file: $e');
    }
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
  TextEditingController _textInput = TextEditingController();
  // String? _textInput = null;
  bool isSwitched = false;

  @override
  void initState() {
    super.initState();
    Provider.of<updateTheImages>(context, listen: false).initializeImages();
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
                        controller: _textInput,
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
                          String Thetext = _textInput.text;
                          if (Thetext != null) {
                            Get.to(
                              const PrettyQrHomePage(),
                              arguments: {
                                'textInput': Thetext,
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
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete'),
              onTap: () {
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Confirmation'),
                      content:
                          Text('Are you sure you want to delete this image?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pop(); // Close confirmation dialog
                          },
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Call removeImage method to delete the image
                            Provider.of<updateTheImages>(context, listen: false)
                                .removeImage(index);
                            Navigator.of(context)
                                .pop(); // Close confirmation dialog
                            // Close options dialog
                          },
                          child: Text('Delete'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text('Share'),
              onTap: () {
                Provider.of<updateTheImages>(context, listen: false)
                    .shareQrCode(index);
                Navigator.pop(context); // Close the options dialog
              },
            ),
          ],
        ),
      );
    },
  );
}
