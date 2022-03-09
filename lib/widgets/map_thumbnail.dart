import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/full_screen_image.dart';

class MapThumbnailImage extends StatelessWidget {
  const MapThumbnailImage({
    Key? key,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  final double latitude;
  final double longitude;

  Uri get _thumbnailUri {
    return Uri(
      scheme: 'https',
      host: 'maps.googleapis.com',
      port: 443,
      path: '/maps/api/staticmap',
      queryParameters: {
        'center': '$latitude,$longitude',
        'zoom': '18',
        'size': '600x300',
        'maptype': 'roadmap',
        'key': 'Map Key',
        'markers': 'color:red|$latitude,$longitude'
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ImageFullScreenWrapperWidget(
      child: Image.network(
        '$_thumbnailUri',
        height: 150.0,
        width: 0.8 * MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
      tag: _thumbnailUri.toString(),
      fullScreenChild: Image.network(
        '$_thumbnailUri',
        fit: BoxFit.contain,
      ),
      dark: false,
    );
  }
}
