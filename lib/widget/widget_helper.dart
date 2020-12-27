import 'package:flutter/material.dart';

class WidgetHelper {
  static Widget getSwitch({
    String title,
    @required bool active,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: active ? Colors.lightGreen : Colors.grey[400],
              ),
            ),
          ),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              color: active ? Colors.lightGreen : Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
