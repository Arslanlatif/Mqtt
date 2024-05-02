
  import 'package:flutter/material.dart';

ElevatedButton button(
      {required VoidCallback onPressed, required Widget child}) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(200, 50),
            backgroundColor: Colors.cyanAccent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
        onPressed: onPressed,
        child: child);
  }
