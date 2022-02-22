import 'package:flutter/material.dart';
import 'package:flutter_application_1/view_models/send_message_view_model.dart';
import 'package:provider/provider.dart';

class SendMessage extends StatefulWidget {
  const SendMessage({Key? key}) : super(key: key);

  @override
  _SendMessageState createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    Provider.of<SendMessageViewModel>(context, listen: false).openTheRecorder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) => SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: Stack(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Consumer<SendMessageViewModel>(
                      builder: (_, sendMessageViewModel, __) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('location:'),
                              if (sendMessageViewModel.locationData != null)
                                Text(sendMessageViewModel.locationData
                                    .toString()),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Text('media:'),
                              if (sendMessageViewModel.pickedMedia != null)
                                Text(sendMessageViewModel.pickedMedia!.path),
                              Text('audio:'),
                              if (sendMessageViewModel.recordedVoice != null)
                                Text(sendMessageViewModel.recordedVoice
                                    .toString()),
                              const SizedBox(
                                height: 10.0,
                              ),
                            ],
                          )),
                ),
              ),
              Positioned(
                bottom: 0,
                child: SizedBox(
                  width: 0.97 * constraints.maxWidth,
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Consumer<SendMessageViewModel>(
                        builder: (_, sendMessageViewModel, __) => Row(
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
                                                sendMessageViewModel.pickMedia(
                                                    isCapture: true,
                                                    isVideo: true);
                                              },
                                              leading: Icon(
                                                Icons.camera_alt_outlined,
                                                color: Colors.blue,
                                              ),
                                              title: Text('Capture Video'),
                                            ),
                                            ListTile(
                                              onTap: () {
                                                sendMessageViewModel
                                                    .pickMedia();
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
                                                sendMessageViewModel.pickMedia(
                                                    isDocument: true);
                                              },
                                              leading: Icon(
                                                Icons.insert_drive_file,
                                                color: Colors.blue,
                                              ),
                                              title: Text('Document'),
                                            ),
                                            ListTile(
                                              onTap: () {
                                                sendMessageViewModel
                                                    .pickLocation();
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
                            if (!sendMessageViewModel.mRecorder!.isRecording)
                              const SizedBox(
                                width: 5.0,
                              ),
                            SizedBox(
                              height: 50.0,
                              child: GestureDetector(
                                onTap: () {
                                  if (sendMessageViewModel
                                      .mRecorder!.isRecording) {
                                    sendMessageViewModel.stopRecorder();
                                  } else {
                                    sendMessageViewModel.record();
                                  }
                                },
                                child: Icon(
                                  sendMessageViewModel.mRecorder!.isRecording
                                      ? Icons.stop
                                      : Icons.mic,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            if (!sendMessageViewModel.mRecorder!.isRecording)
                              const SizedBox(
                                width: 10.0,
                              ),
                            if (!sendMessageViewModel.mRecorder!.isRecording)
                              GestureDetector(
                                onTap: () {
                                  sendMessageViewModel.pickMedia(
                                      isCapture: true);
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
                              child: sendMessageViewModel.mRecorder!.isRecording
                                  ? TweenAnimationBuilder<Duration>(
                                      duration: Duration(seconds: 60),
                                      tween: Tween(
                                          begin: Duration.zero,
                                          end: Duration(seconds: 60)),
                                      onEnd: () {
                                        sendMessageViewModel.stopRecorder();
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
                ),

                // )
              )
            ],
          ),
        ),
      ),
    );
  }
}
