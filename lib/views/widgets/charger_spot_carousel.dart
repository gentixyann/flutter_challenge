import 'package:flutter/material.dart';
import 'package:flutter_map_app/providers/carousel_provider.dart';
import 'package:flutter_map_app/providers/charger_spot_provider.dart';
import 'package:flutter_map_app/providers/google_map_provider.dart';
import 'package:flutter_map_app/providers/location_provider.dart';
import 'package:flutter_map_app/views/widgets/charger_spot_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChargerSpotCarousel extends ConsumerWidget {
  const ChargerSpotCarousel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chargerSpots = ref.watch(chargerSpotListProvider);
    final pageController = ref.watch(pageControllerProvider);
    final mapController = ref.watch(mapControllerProvider);

    return SizedBox(
      height: 280,
      child: PageView.builder(
        controller: pageController,
        itemCount: chargerSpots.length,
        onPageChanged: (int index) async {
          final selectedSpot = chargerSpots.elementAt(index);
          ref.read(selectedChargerSpotProvider.notifier).state = selectedSpot;
          if (mapController != null) {
            await ref.read(moveCameraProvider)(
              mapController: mapController,
              latitude: selectedSpot.latitude,
              longitude: selectedSpot.longitude,
            );
          }
        },
        itemBuilder: (context, index) {
          final spot = chargerSpots[index];
          return ChargerSpotCard(chargerSpot: spot);
        },
      ),
    );
  }
}
