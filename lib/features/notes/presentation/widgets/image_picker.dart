import 'package:image_picker/image_picker.dart';

class ImagePickerUtil {

  static Future<String?> pickImage() async {

    final picker = ImagePicker();

    final file = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (file == null) {
      return null;
    }

    return file.path;
  }
}