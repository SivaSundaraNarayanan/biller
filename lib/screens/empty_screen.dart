import 'package:flutter/material.dart';

class EmptyScreen extends StatelessWidget {
  final String title;

  const EmptyScreen({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sentiment_dissatisfied,
            size: 48,
            color: Colors.grey,
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            'There are no ${title.toLowerCase()}',
            style: TextStyle(
              fontSize: 19,
              color: Colors.grey[700],
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            'Click the + button to add new ${title.toLowerCase()}s',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black38,
            ),
          ),
        ],
      ),
    );
  }
}
