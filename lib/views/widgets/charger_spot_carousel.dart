import 'package:flutter/material.dart';
import 'package:flutter_map_app/providers/charger_spot_provider.dart';
import 'package:flutter_map_app/views/widgets/charger_spot_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChargerSpotCarousel extends ConsumerWidget {
  const ChargerSpotCarousel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chargerSpots = ref.watch(chargerSpotListProvider);

    if (chargerSpots.isEmpty) {
      return const Center(
        child: Text(
          "近くに充電スポットが見つかりませんでした。",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
    }

    return SizedBox(
      height: 280,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.85),
        itemCount: chargerSpots.length,
        itemBuilder: (context, index) {
          final spot = chargerSpots[index];
          return ChargerSpotCard(chargerSpot: spot);
        },
      ),
    );
  }
}
