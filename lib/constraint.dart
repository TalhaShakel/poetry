import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

const double kToolbarHeight = 56.0;
Color kcolor = Color.fromARGB(255, 7, 73, 206);
showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
  print('No Image Selected');
}
