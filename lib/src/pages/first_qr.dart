import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:qrcodegenerator/src/pages/fullImageView.dart';
import 'package:qrcodegenerator/src/pages/pretty_qr.dart';
import 'package:qrcodegenerator/src/settings/settings_page.dart';
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
  return jogtest;
}

Future<void> deleteImageFromPrefs(String key) async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  } catch (e) {}
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
  }

  Future<void> shareQrCode(int index) async {
    String imagePath = savedImages[index];

    try {
      if (imagePath != null) {
        // Share the temporary file
        await Share.shareXFiles([XFile(imagePath)], text: 'Great picture');

        // Delete the temporary file after sharing
      } else {}
    } catch (e) {}
  }

  Future<void> deleteImageFile(String imagePath) async {
    try {
      final File imageFile = File(imagePath);
      if (await imageFile.exists()) {
        await imageFile.delete();
      } else {}
    } catch (e) {}
  }

  Future<void> initializeImages() async {
    savedImages = await getSavedImages();
    notifyListeners();
  }
}

class FileUploadView extends StatefulWidget {
  const FileUploadView({Key? key}) : super(key: key);

  @override
  FileUploadViewState createState() => FileUploadViewState();
}

class FileUploadViewState extends State<FileUploadView> {
  final TextEditingController _textInput = TextEditingController();
  // String? _textInput = null;
  bool isSwitched = false;

  @override
  void initState() {
    super.initState();
    Provider.of<updateTheImages>(context, listen: false).initializeImages();
  }

  @override
  void dispose() {
    _textInput.dispose();
    super.dispose();
  }
  // Method to initialize savedImages list

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            
            foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
            iconTheme: Theme.of(context).appBarTheme.iconTheme,
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            title: const Text('QrCode Generator'),
            titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
            automaticallyImplyLeading: false,
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  Get.to(const SettingsPage());
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
                                  'To add an image link or a file link\n 1. Upload your file to a cloud storage platform like:',
                                  style: Theme.of(context).textTheme.bodyLarge),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text('- iCloud',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text('- Google Drive',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text(
                                  '- Dropbox',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
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
                          decoration: InputDecoration(
                            labelText: "Enter URL",
                            labelStyle: TextStyle(
                                fontSize: 16, color: Colors.grey[600]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: Theme.of(context).elevatedButtonTheme.style,
                          onPressed: () {
                            String Thetext = _textInput.text;
                            if (Thetext != "") {
                              Get.to(
                                const PrettyQrHomePage(),
                                arguments: {
                                  'textInput': Thetext,
                                },
                              );
                            } else {
                              // Show a Snackbar message if _textInput is empty
                              Get.snackbar(
                                animationDuration: const Duration(microseconds: 3000),
                                duration: const Duration(milliseconds: 1500),
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                      },
                      onTap: () {
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
                                  child:
                                      Text(imageName), // Displaying image name
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
        title: const Text('Options'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () {
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirmation'),
                      content:
                          const Text('Are you sure you want to delete this image?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pop(); // Close confirmation dialog
                          },
                          child: const Text('Cancel'),
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
                          child: const Text('Delete'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
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
