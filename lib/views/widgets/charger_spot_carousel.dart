import 'package:flutter/material.dart';
import 'package:flutter_map_app/views/widgets/charger_spot_card.dart';

class ChargerSpotCarousel extends StatelessWidget {
  const ChargerSpotCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.85),
        itemCount: 3, // カードの数
        itemBuilder: (context, index) {
          return const ChargerSpotCard();
        },
      ),
    );
  }
}
