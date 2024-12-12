// ignore_for_file: constant_identifier_names

import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }
  // ignore: avoid_print
  print('No Image Selected');
}

// Used to check wheter the User logged in or not
const save_State = 'UserLoggin';

