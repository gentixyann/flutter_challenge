import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_app/theme.dart';

class MyLocationButton extends StatelessWidget {
  const MyLocationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(55, 55),
          backgroundColor: ThemeColor.darkGray,
          foregroundColor: ThemeColor.white,
          shape: const CircleBorder(),
        ),
        onPressed: () => print('現在地へ'),
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
