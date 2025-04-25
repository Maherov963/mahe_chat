// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';

// class MyPhotoPicker {
//   final ImagePicker picker = ImagePicker();
//   String? path;
//   Future<String?> fromGallery() async {
//     await picker
//         .pickImage(source: ImageSource.gallery, imageQuality: 50)
//         .then((value) async {
//       path = await imageCroper(value?.path);
//     });
//     return path;
//   }

//   Future<String?> fromCamera() async {
//     await picker
//         .pickImage(source: ImageSource.camera, imageQuality: 50)
//         .then((value) async {
//       path = await imageCroper(value?.path);
//     });
//     return path;
//   }

//   Future<String?> imageCroper(String? path) async {
//     if (path == null) {
//       return path;
//     } else {
//       CroppedFile? croppedFile = await ImageCropper().cropImage(
//           sourcePath: path,
//           maxHeight: 500,
//           maxWidth: 500,
//           aspectRatio: const CropAspectRatio(ratioX: 500, ratioY: 500),
//           uiSettings: [
//             AndroidUiSettings(
//               toolbarTitle: 'Cropper',
//               // toolbarColor: Theme.of(context).scaffoldBackgroundColor,
//               initAspectRatio: CropAspectRatioPreset.original,
//               lockAspectRatio: true,
//               // statusBarColor: Theme.of(context).scaffoldBackgroundColor,
//             ),
//           ]);
//       return croppedFile?.path;
//     }
//   }
// }
