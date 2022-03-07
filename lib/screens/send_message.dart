import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/custom_message.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';

import 'package:flutter_application_1/view_models/send_message_view_model.dart';
import 'package:flutter_application_1/widgets/app_video_player.dart';
import 'package:flutter_application_1/widgets/audio_player_chat.dart';
import 'package:flutter_application_1/widgets/full_screen_image.dart';
import 'package:flutter_application_1/widgets/map_thumbnail.dart';

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

    //this function give u a thumbnail of video
    Provider.of<SendMessageViewModel>(context, listen: false).getThumbnail(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Consumer<SendMessageViewModel>(
                        builder: (_, sendMessageViewModel, __) {
                      return ListView(
                        children: [
                          Text('location:'),
                          const SizedBox(height: 10.0),
                          if (sendMessageViewModel.locationData != null)
                            CustomMessage(
                              child: MapThumbnailImage(
                                latitude: sendMessageViewModel
                                    .locationData!.latitude!,
                                longitude: sendMessageViewModel
                                    .locationData!.longitude!,
                              ),
                            ),
                          const SizedBox(height: 10.0),
                          Text('media:'),
                          const SizedBox(height: 10.0),
                          CustomMessage(
                            child: Container(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      0.8 * MediaQuery.of(context).size.width,
                                  minHeight: 100.0,
                                  maxHeight: 200),
                              child: ImageFullScreenWrapperWidget(
                                child: Image.network(
                                  'https://cdn.pixabay.com/photo/2019/07/30/18/26/surface-4373559_960_720.jpg',
                                  fit: BoxFit.contain,
                                ),
                                tag:
                                    'https://cdn.pixabay.com/photo/2019/07/30/18/26/surface-4373559_960_720.jpg',
                                fullScreenChild: Image.network(
                                  'https://cdn.pixabay.com/photo/2019/07/30/18/26/surface-4373559_960_720.jpg',
                                  fit: BoxFit.contain,
                                ),
                                dark: false,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          if (sendMessageViewModel.videoThumbnail != null)
                            CustomMessage(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => AppVideoPlayer(
                                                link:
                                                    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
                                              )));
                                },
                                child: Container(
                                  constraints: BoxConstraints(
                                      maxWidth: 0.8 *
                                          MediaQuery.of(context).size.width,
                                      minHeight: 100.0,
                                      maxHeight: 200),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Image.file(
                                        sendMessageViewModel.videoThumbnail!,
                                        fit: BoxFit.contain,
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: CircleAvatar(
                                          child: Icon(Icons.play_arrow),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 10.0),
                          if (sendMessageViewModel.pickedMedia != null)
                            CustomMessage(
                              child: SizedBox(
                                width: 0.7 * MediaQuery.of(context).size.width,
                                child: GestureDetector(
                                  onTap: () {
                                    sendMessageViewModel.openFile();
                                  },
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          path.basename(sendMessageViewModel
                                              .pickedMedia!.path),
                                          style: TextStyle(color: Colors.white),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 10.0),
                                      CircleAvatar(
                                        child: Icon(Icons.folder_open),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          const SizedBox(height: 10.0),
                          Text('audio:'),
                          const SizedBox(height: 10.0),
                          AudioPlayerSection(
                            link:
                                'https://sampleswap.org/samples-ghost/DRUM%20LOOPS%20and%20BREAKS/000%20to%20080%20bpm/827[kb]050_barbituate-beat.wav.mp3',
                            isLocale: false,
                          ),
                          const SizedBox(height: 10.0),
                          Text('Text:'),
                          const SizedBox(height: 10.0),
                          if (sendMessageViewModel.text != null)
                            CustomMessage(
                              child: ParsedText(
                                style: TextStyle(color: Colors.white),
                                text: sendMessageViewModel.text!,
                                parse: <MatchText>[
                                  MatchText(
                                    type: ParsedType.EMAIL,
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16,
                                      height: 2,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    onTap: (url) {
                                      sendMessageViewModel
                                          .launchURL("mailto:" + url);
                                    },
                                  ),
                                  MatchText(
                                    type: ParsedType.URL,
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 16,
                                      height: 2,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    onTap: (url) {
                                      sendMessageViewModel.launchURL(url);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 10.0),
                        ],
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 5.0),
                Divider(
                  indent: 10.0,
                  endIndent: 10.0,
                  thickness: 1,
                  height: 1,
                ),
                IntrinsicHeight(
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
                                              sendMessageViewModel.pickMedia();
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
                                sendMessageViewModel.pickMedia(isCapture: true);
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
                                    maxLines: 5,
                                    minLines: 1,
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
                            onTap: () async {
                              sendMessageViewModel.setText =
                                  _textController.text;
                              _textController.clear();
                            },
                            child: const Icon(
                              Icons.send_outlined,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
