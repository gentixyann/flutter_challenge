import 'package:flutter/material.dart';
import 'package:flutter_map_app/views/widgets/my_location_button.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: MyLocationButton(),
        ),
        SizedBox(height: 20),
        Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Center(
              child: Text(
                "近くに充電スポットが見つかりませんでした。",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            )),
      ],
    );
  }
}
