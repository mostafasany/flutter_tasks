import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:location/location.dart' as loc;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

const theSource = AudioSource.microphone;

class SendMessage extends StatefulWidget {
  const SendMessage({Key? key}) : super(key: key);

  @override
  _SendMessageState createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  TextEditingController _textController = TextEditingController();
  File? _pickedMedia;
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
        type: FileType.any,
      );
    }
    setState(() {
      print('set state ');
      if (result != null && result.files.single.path != null) {
        _pickedMedia = File(result.files.single.path!);
        print('result');
      } else if (media != null) {
        print('media');
        _pickedMedia = File(media.path);
        print(_pickedMedia);
      }
    });
  }

  loc.LocationData? _locationData;

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

    _locationData = await location.getLocation();
    print(_locationData);
  }

  var dir = Directory.systemTemp.createTempSync();
  File? _recordedVoice;

  Codec _codec = Codec.aacMP4;
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  void stopRecorder() async {
    await _mRecorder!.stopRecorder().then((value) {
      setState(() {});
    });
  }

  void record() async {
    String uniqueKey = UniqueKey().toString();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    _recordedVoice = File("$tempPath/$uniqueKey.aac");

    _mRecorder!
        .startRecorder(
      toFile: _recordedVoice!.path,
      codec: _codec,
      audioSource: theSource,
    )
        .then((value) {
      setState(() {});
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
    await _mRecorder!.openAudioSession();
  }

  @override
  void initState() {
    openTheRecorder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) => Stack(
          children: [
            Positioned(
              bottom: 0,
              child: SizedBox(
                width: 0.97 * constraints.maxWidth,
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 50.0,
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (ctx) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          onTap: () {
                                            pickMedia(
                                                isCapture: true, isVideo: true);
                                          },
                                          leading: Icon(
                                            Icons.camera_alt_outlined,
                                            color: Colors.blue,
                                          ),
                                          title: Text('Capture Video'),
                                        ),
                                        ListTile(
                                          onTap: () {
                                            pickMedia();
                                          },
                                          leading: Icon(
                                            Icons.image_outlined,
                                            color: Colors.blue,
                                          ),
                                          title: Text(
                                              'Video or Photo from gallery'),
                                        ),
                                        ListTile(
                                          onTap: () {
                                            pickMedia(isDocument: true);
                                          },
                                          leading: Icon(
                                            Icons.insert_drive_file,
                                            color: Colors.blue,
                                          ),
                                          title: Text('Document'),
                                        ),
                                        ListTile(
                                          onTap: () {
                                            pickLocation();
                                          },
                                          leading: Icon(
                                            Icons.location_on_outlined,
                                            color: Colors.blue,
                                          ),
                                          title: Text('Location'),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Icon(
                              Icons.add,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        if (!_mRecorder!.isRecording)
                          const SizedBox(
                            width: 5.0,
                          ),
                        SizedBox(
                          height: 50.0,
                          child: GestureDetector(
                            onTap: () {
                              if (_mRecorder!.isRecording) {
                                stopRecorder();
                              } else {
                                record();
                              }
                            },
                            child: Icon(
                              _mRecorder!.isRecording ? Icons.stop : Icons.mic,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        if (!_mRecorder!.isRecording)
                          const SizedBox(
                            width: 10.0,
                          ),
                        if (!_mRecorder!.isRecording)
                          GestureDetector(
                            onTap: () {
                              pickMedia(isCapture: true);
                            },
                            child: Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.blue,
                            ),
                          ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: _mRecorder!.isRecording
                              ? TweenAnimationBuilder<Duration>(
                                  duration: Duration(seconds: 60),
                                  tween: Tween(
                                      begin: Duration.zero,
                                      end: Duration(seconds: 60)),
                                  onEnd: () {
                                    stopRecorder();
                                  },
                                  builder: (BuildContext context,
                                      Duration value, Widget? child) {
                                    final minutes = value.inMinutes;
                                    final seconds = value.inSeconds % 60;
                                    return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Text('$minutes:$seconds',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)));
                                  })
                              : TextField(
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                  textDirection: TextDirection.ltr,
                                  controller: _textController,
                                  decoration: InputDecoration(
                                    hintText: 'start discussion',
                                    contentPadding: EdgeInsets.all(0.0),
                                  ),
                                ),
                        ),
                        VerticalDivider(
                          color: Colors.grey.shade300,
                          indent: 15.0,
                          endIndent: 15.0,
                          thickness: 1,
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        GestureDetector(
                          onTap: () async {},
                          child: const Icon(
                            Icons.send_outlined,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // )
            )
          ],
        ),
      ),
    );
  }
}
