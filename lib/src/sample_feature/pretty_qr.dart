import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:provider/provider.dart';
import 'package:qrcodescanner/src/sample_feature/first_qr.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isImageSelected = false;

class PrettyQrHomePage extends StatefulWidget {
  const PrettyQrHomePage({
    super.key,
  });

  @override
  State<PrettyQrHomePage> createState() => _PrettyQrHomePageState();
}

class _PrettyQrHomePageState extends State<PrettyQrHomePage> {
  String _data = Get.arguments['textInput'];

  @protected
  late QrCode qrCode;

  @protected
  late QrImage qrImage;

  @protected
  late PrettyQrDecoration decoration;

  @override
  void initState() {
    super.initState();

    qrCode = QrCode.fromData(
      data: _data,
      errorCorrectLevel: QrErrorCorrectLevel.H,
    );

    qrImage = QrImage(qrCode);

    decoration = const PrettyQrDecoration(
      shape: PrettyQrSmoothSymbol(
        color: Color(0xFF74565F),
      ),
      image: null,
    );
  }

  Future<void> _shareQrCode() async {
    try {
      final imageData = await qrImage.toImageAsBytes(
        size: 800, // Adjust the size as needed
        format: ImageByteFormat.png,
        decoration: decoration,
      );

      if (imageData != null) {
        // Get the temporary directory path
        final tempDir = await getTemporaryDirectory();
        final tempFilePath =
            '${tempDir.path}/qr_code.png'; // Append filename to directory path

        // Write the image data to a temporary file
        final tempFile = File(tempFilePath);
        await tempFile.writeAsBytes(
          imageData.buffer.asUint8List(),
          mode: FileMode.write,
        );
        print('saved to ${tempFilePath}');

        // Share the temporary file
        await Share.shareXFiles([XFile('${tempFilePath}')],
            text: 'Great picture');

        // Delete the temporary file after sharing
        await tempFile.delete();
      } else {
        print('Error: Unable to share QR code');
      }
    } catch (e) {
      print('Error sharing QR code: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('QrCode Generator'),
        actions: [
          GestureDetector(
              onTap: () {
                _shareQrCode();
              },
              child: Icon(Icons.share))
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 1024,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final safePadding = MediaQuery.of(context).padding;
              double containerHeight =
                  MediaQuery.of(context).size.height * 0.35;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (constraints.maxWidth >= 720)
                    Flexible(
                      flex: 3,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: safePadding.left + 24,
                          right: safePadding.right + 24,
                          bottom: 24,
                        ),
                        child: _PrettyQrAnimatedView(
                          qrImage: qrImage,
                          decoration: decoration,
                        ),
                      ),
                    ),
                  Flexible(
                    flex: 2,
                    child: Column(
                      children: [
                        if (constraints.maxWidth < 720)
                          Padding(
                            padding: safePadding.copyWith(
                              top: 15,
                              bottom: 15,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 244, 244, 244),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              height: containerHeight,
                              child: _PrettyQrAnimatedView(
                                qrImage: qrImage,
                                decoration: decoration,
                              ),
                            ),
                          ),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: safePadding.copyWith(top: 0),
                            child: _PrettyQrSettings(
                              decoration: decoration,
                              onChanged: (value) => setState(() {
                                decoration = value;
                              }),
                              onExportPressed: (size) async {
                                try {
                                  final imageBytes =
                                      await qrImage.toImageAsBytes(
                                    size: 800, // Adjust the size as needed
                                    format: ImageByteFormat.png,
                                    decoration: decoration,
                                  );

                                  if (imageBytes != null) {
                                    final tempDir =
                                        await getTemporaryDirectory();
                                    final tempFilePath =
                                        '${tempDir.path}/qr_code${DateTime.now().millisecondsSinceEpoch}.png';
                                    final tempFile = File(tempFilePath);
                                    await tempFile.writeAsBytes(
                                      imageBytes.buffer.asUint8List(),
                                      mode: FileMode.write,
                                    );

                                    // Save the image path to cache
                                    final SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    final uniqueId =
                                        DateTime.now().millisecondsSinceEpoch;
                                    final key =
                                        'saved_image_$uniqueId'; // Unique key for each image
                                    await prefs.setString(key, tempFilePath);

                                    waitForImage(context);
                                    print('Saved to $tempFilePath');
                                    // Display a snackbar to indicate successful export
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                            'QR code saved successfully'),
                                      ),
                                    );
                                  } else {
                                    print('Error: Unable to export QR code');
                                  }
                                } catch (e) {
                                  print('Error exporting QR code: $e');
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PrettyQrAnimatedView extends StatefulWidget {
  @protected
  final QrImage qrImage;

  @protected
  final PrettyQrDecoration decoration;

  const _PrettyQrAnimatedView({
    required this.qrImage,
    required this.decoration,
  });

  @override
  State<_PrettyQrAnimatedView> createState() => _PrettyQrAnimatedViewState();
}

class _PrettyQrAnimatedViewState extends State<_PrettyQrAnimatedView> {
  @protected
  late PrettyQrDecoration previosDecoration;

  @override
  void initState() {
    super.initState();

    previosDecoration = widget.decoration;
  }

  @override
  void didUpdateWidget(
    covariant _PrettyQrAnimatedView oldWidget,
  ) {
    super.didUpdateWidget(oldWidget);
    isImageSelected = widget.decoration.image != null;

    if (widget.decoration != oldWidget.decoration) {
      previosDecoration = oldWidget.decoration;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TweenAnimationBuilder<PrettyQrDecoration>(
        tween: PrettyQrDecorationTween(
          begin: previosDecoration,
          end: widget.decoration,
        ),
        curve: Curves.ease,
        duration: const Duration(
          milliseconds: 240,
        ),
        builder: (context, decoration, child) {
          return PrettyQrView(
            qrImage: widget.qrImage,
            decoration: decoration,
          );
        },
      ),
    );
  }
}

class _PrettyQrSettings extends StatefulWidget {
  @protected
  final PrettyQrDecoration decoration;

  @protected
  final Future<String?> Function(int)? onExportPressed;

  @protected
  final ValueChanged<PrettyQrDecoration>? onChanged;

  @visibleForTesting
  static const kDefaultPrettyQrDecorationImage = PrettyQrDecorationImage(
    image: AssetImage('assets/images/flutter_logo.png'),
    position: PrettyQrDecorationImagePosition.embedded,
  );

  const _PrettyQrSettings({
    required this.decoration,
    this.onChanged,
    this.onExportPressed,
  });

  @override
  State<_PrettyQrSettings> createState() => _PrettyQrSettingsState();
}

class _PrettyQrSettingsState extends State<_PrettyQrSettings> {
  @protected
  late final TextEditingController imageSizeEditingController;

  @override
  void initState() {
    super.initState();
    isImageSelected = widget.decoration.image != null;
    imageSizeEditingController = TextEditingController(
      text: ' 512w',
    );
  }

  @protected
  int get imageSize {
    final rawValue = imageSizeEditingController.text;
    return int.parse(rawValue.replaceAll('w', '').replaceAll(' ', ''));
  }

  @protected
  Color get shapeColor {
    var shape = widget.decoration.shape;
    if (shape is PrettyQrSmoothSymbol) return shape.color;
    if (shape is PrettyQrRoundedSymbol) return shape.color;
    return Colors.black;
  }

  @protected
  bool get isRoundedBorders {
    var shape = widget.decoration.shape;
    if (shape is PrettyQrSmoothSymbol) {
      return shape.roundFactor > 0;
    } else if (shape is PrettyQrRoundedSymbol) {
      return shape.borderRadius != BorderRadius.zero;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return PopupMenuButton(
              onSelected: changeShape,
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
              ),
              initialValue: widget.decoration.shape.runtimeType,
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                    value: PrettyQrSmoothSymbol,
                    child: Text('Smooth'),
                  ),
                  const PopupMenuItem(
                    value: PrettyQrRoundedSymbol,
                    child: Text('Rounded rectangle'),
                  ),
                ];
              },
              child: ListTile(
                leading: const Icon(Icons.format_paint_outlined),
                title: const Text('Style'),
                trailing: Text(
                  widget.decoration.shape is PrettyQrSmoothSymbol
                      ? 'Smooth'
                      : 'Rounded rectangle',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            );
          },
        ),
        SwitchListTile.adaptive(
          value: isRoundedBorders,
          onChanged: (value) => toggleRoundedCorners(),
          secondary: const Icon(Icons.rounded_corner),
          title: const Text('Rounded corners'),
        ),
        const Divider(),
        SwitchListTile.adaptive(
          value: shapeColor != Colors.black,
          onChanged: (value) => toggleColor(),
          secondary: const Icon(Icons.color_lens_outlined),
          title: const Text('Colored'),
        ),
        if (shapeColor != Colors.black)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => showColorDialog(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            currentColor != null
                                ? colorValueToString(
                                    currentColor) // Format color value here
                                : 'Pick a background color',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                              width: 8), // Add spacing between text and icon
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        const Divider(),
        SwitchListTile.adaptive(
          value: widget.decoration.image != null,
          onChanged: (value) => toggleImage(),
          secondary: Icon(
            widget.decoration.image != null
                ? Icons.image_outlined
                : Icons.hide_image_outlined,
          ),
          title: const Text('Image'),
        ),
        if (widget.decoration.image != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showOptionsModal(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _selectedOption ?? 'Choose Image',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                              width: 8), // Add spacing between text and icon
                          const Icon(Icons.image), // Use a more specific icon
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (widget.decoration.image != null)
          ListTile(
            enabled: widget.decoration.image != null,
            leading: const Icon(Icons.layers_outlined),
            title: const Text('Image position'),
            trailing: PopupMenuButton(
              onSelected: changeImagePosition,
              initialValue: widget.decoration.image?.position,
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                    value: PrettyQrDecorationImagePosition.embedded,
                    child: Text('Embedded'),
                  ),
                  const PopupMenuItem(
                    value: PrettyQrDecorationImagePosition.foreground,
                    child: Text('Foreground'),
                  ),
                  const PopupMenuItem(
                    value: PrettyQrDecorationImagePosition.background,
                    child: Text('Background'),
                  ),
                ];
              },
            ),
          ),
        if (widget.onExportPressed != null) ...[
          const Divider(),
          ListTile(
            leading: const Icon(Icons.save_alt_outlined),
            title: const Text('Export'),
            onTap: () async {
              final path = await widget.onExportPressed?.call(imageSize);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(path == null ? 'Saved' : 'Saved to $path'),
                ),
              );
            },
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PopupMenuButton(
                  initialValue: imageSize,
                  onSelected: (value) {
                    imageSizeEditingController.text = ' ${value}w';
                    setState(() {});
                  },
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                        value: 256,
                        child: Text('256w'),
                      ),
                      const PopupMenuItem(
                        value: 512,
                        child: Text('512w'),
                      ),
                      const PopupMenuItem(
                        value: 1024,
                        child: Text('1024w'),
                      ),
                    ];
                  },
                  child: SizedBox(
                    width: 72,
                    height: 36,
                    child: TextField(
                      enabled: false,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                      controller: imageSizeEditingController,
                      decoration: InputDecoration(
                        filled: true,
                        counterText: '',
                        contentPadding: EdgeInsets.zero,
                        fillColor: Theme.of(context).colorScheme.background,
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  String colorValueToString(Color color) {
    String hexValue =
        '#${color.value.toRadixString(16).padLeft(16, '0').toUpperCase()}';
    return hexValue;
  }

  @protected
  void changeShape(
    final Type type,
  ) {
    var shape = widget.decoration.shape;
    if (shape.runtimeType == type) return;

    if (shape is PrettyQrSmoothSymbol) {
      shape = PrettyQrRoundedSymbol(color: shapeColor);
    } else if (shape is PrettyQrRoundedSymbol) {
      shape = PrettyQrSmoothSymbol(color: shapeColor);
    }

    widget.onChanged?.call(widget.decoration.copyWith(shape: shape));
  }

  @protected
  void toggleColor() {
    var shape = widget.decoration.shape;
    var color = shapeColor != Colors.black ? Colors.black : currentColor;

    if (shape is PrettyQrSmoothSymbol) {
      shape = PrettyQrSmoothSymbol(
        color: color,
        roundFactor: shape.roundFactor,
      );
    } else if (shape is PrettyQrRoundedSymbol) {
      shape = PrettyQrRoundedSymbol(
        color: color,
        borderRadius: shape.borderRadius,
      );
    }

    widget.onChanged?.call(widget.decoration.copyWith(shape: shape));
  }

  @protected
  void toggleRoundedCorners() {
    var shape = widget.decoration.shape;

    if (shape is PrettyQrSmoothSymbol) {
      shape = PrettyQrSmoothSymbol(
        color: shape.color,
        roundFactor: isRoundedBorders ? 0 : 1,
      );
    } else if (shape is PrettyQrRoundedSymbol) {
      shape = PrettyQrRoundedSymbol(
        color: shape.color,
        borderRadius: isRoundedBorders
            ? BorderRadius.zero
            : const BorderRadius.all(Radius.circular(10)),
      );
    }

    widget.onChanged?.call(widget.decoration.copyWith(shape: shape));
  }

  bool isImageEnabled = false;
  // @protected
  // void toggleImage() {
  //   setState(() {
  //     isImageEnabled = !isImageEnabled;
  //   });
  //   final image = isImageEnabled ? widget.decoration.image : null;

  //   widget.onChanged?.call(
  //     PrettyQrDecoration(image: image, shape: widget.decoration.shape),
  //   );
  // }

  @protected
  @protected
  void toggleImage() {
    final image = widget.decoration.image != null
        ? null
        : _PrettyQrSettings.kDefaultPrettyQrDecorationImage;

    widget.onChanged?.call(
      PrettyQrDecoration(image: image, shape: widget.decoration.shape),
    );
  }

  @protected
  void changeImagePosition(
    final PrettyQrDecorationImagePosition value,
  ) {
    final image = widget.decoration.image?.copyWith(position: value);
    widget.onChanged?.call(widget.decoration.copyWith(image: image));
  }

  String? _selectedOption;

  final List<Map<String, String>> _options = [
    {'label': 'Option 1', 'imagePath': 'assets/images/flutter_logo.png'},
    {'label': 'Option 2', 'imagePath': 'assets/images/book-stack.png'},
    {'label': 'Option 3', 'imagePath': 'assets/images/dumbbell.png'},
    {'label': 'Option 4', 'imagePath': 'assets/images/restaurant.png'},
    {'label': 'Option 5', 'imagePath': 'assets/images/wi-fi.png'},
  ];

  void _showOptionsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: _options.length,
                  itemBuilder: (context, index) {
                    final option = _options[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          String? filepath = option['imagePath'];
                          isImageSelected = true;
                          _selectedOption = path.basename(filepath!);
                          widget.onChanged?.call(
                            widget.decoration.copyWith(
                              image: PrettyQrDecorationImage(
                                image: AssetImage(option['imagePath']!),
                                position:
                                    PrettyQrDecorationImagePosition.embedded,
                              ),
                            ),
                          );
                        });
                        Navigator.pop(context);
                      },
                      child: Card(
                        elevation: 3,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                option['imagePath']!,
                                width: 20,
                                height: 20,
                                fit: BoxFit.contain,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      String? filepath = await _openFileExplorer();
                      if (filepath != null) {
                        setState(() {
                          isImageSelected = true;
                          _selectedOption = path.basename(filepath);
                        });
                        widget.onChanged?.call(
                          widget.decoration.copyWith(
                            image: PrettyQrDecorationImage(
                              image: FileImage(File(filepath)),
                              position:
                                  PrettyQrDecorationImagePosition.embedded,
                            ),
                          ),
                        );

                        print(filepath);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Upload a file'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Close'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Color pickerColor = Color.fromARGB(255, 157, 11, 230);
  Color currentColor = Color(0xff443a49);

// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() {
      // Update both pickerColor and currentColor for consistency
      pickerColor = color;
      currentColor = color;
    });
  }

  void showColorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              paletteType: PaletteType.hslWithHue,
              displayThumbColor: true,
              hexInputBar: true, enableAlpha: true,
              pickerColor: pickerColor,
              onColorChanged: changeColor, // Simplified callback reference
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Got it'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String? _filePath;
  final String _textInput = '';

  Future<String?> _openFileExplorer() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'jpg',
          'jpeg',
          'png',
          'pdf'
              'svg'
        ], // Customize allowed file extensions
      );

      if (result != null) {
        setState(() {
          isImageSelected = true;
        });
        _filePath = result.files.single.path!;
        print("from the esplorer:${_filePath}");
        return result.files.single.path;
      }
    } catch (e) {
      print('Error picking file: $e');
    }
    return null; // Return null if no file was selected or an error occurred
  }

  // void _clearImage() {
  //   setState(() {
  //     _filePath = null;
  //   });
  // }

  @override
  void dispose() {
    imageSizeEditingController.dispose();

    super.dispose();
  }
}

void waitForImage(BuildContext context) {
  context.read<updateTheImages>().initializeImages();
}
