import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:location/location.dart' as loc;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

const theSource = AudioSource.microphone;

class SendMessageViewModel extends ChangeNotifier {
  loc.LocationData? locationData;

  pickLocation() async {
    loc.Location location = loc.Location();

    bool _serviceEnabled;
    loc.PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == loc.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != loc.PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
  }

  File? pickedMedia;
  pickMedia(
      {bool isCapture = false,
      bool isVideo = false,
      bool isDocument = false}) async {
    final ImagePicker _picker = ImagePicker();
    XFile? media;
    FilePickerResult? result;

    if (isDocument) {
      result = await FilePicker.platform.pickFiles(type: FileType.any);
    } else if (isCapture) {
      if (isVideo) {
        media = await _picker.pickVideo(source: ImageSource.camera);
      } else {
        media = await _picker.pickImage(source: ImageSource.camera);
      }
    } else {
      result = await FilePicker.platform.pickFiles(
        type: FileType.media,
      );
    }
    if (result != null && result.files.single.path != null) {
      pickedMedia = File(result.files.single.path!);
    } else if (media != null) {
      pickedMedia = File(media.path);
    }
  }

  File? _recordedVoice;

  Codec _codec = Codec.aacMP4;
  FlutterSoundRecorder? mRecorder = FlutterSoundRecorder();
  void stopRecorder() async {
    await mRecorder!.stopRecorder().then((value) {
      notifyListeners();
    });
  }

  void record() async {
    String uniqueKey = UniqueKey().toString();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    _recordedVoice = File("$tempPath/$uniqueKey.aac");

    mRecorder!
        .startRecorder(
      toFile: _recordedVoice!.path,
      codec: _codec,
      audioSource: theSource,
    )
        .then((value) {
      notifyListeners();
    });
  }

  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        print('granted');
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await mRecorder!.openAudioSession();
  }
}
