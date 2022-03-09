import 'package:flutter/material.dart';

class MatchResultScreen extends StatelessWidget {
  const MatchResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle _textStyle = TextStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.0);
    return Scaffold(
      body: Center(
        child: Container(
          height: 170.0,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                  'https://images.alphacoders.com/510/thumb-1920-510026.jpg'),
            ),
          ),
          child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.black26),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'England, FA Cup - 5th Round',
                      style: _textStyle,
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.network(
                          'https://assets.stickpng.com/images/580b57fcd9996e24bc43c4e5.png',
                          height: 100.0,
                        ),
                        Column(
                          children: [
                            Text(
                              'Today',
                              style: _textStyle,
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              '9:49:12',
                              style: _textStyle,
                            ),
                            const SizedBox(height: 5.0),
                            Text(
                              '22:15',
                              style: _textStyle,
                            ),
                          ],
                        ),
                        Image.network(
                          'https://assets.stickpng.com/images/580b57fcd9996e24bc43c4e5.png',
                          height: 100.0,
                        ),
                      ],
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
