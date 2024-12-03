import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_app/providers/charger_spot_provider.dart';
import 'package:flutter_map_app/providers/location_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapController = ref.watch(_Providers.mapController);
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: ref.watch(tokyoStationLocation),
        myLocationEnabled: true,
        markers: ref.watch(sampleMarker),
        onMapCreated: (GoogleMapController controller) {
          ref.read(_Providers.mapController.notifier).state = controller;
        },
        onCameraIdle: () async {
          if (mapController != null) {
            final bounds = await mapController.getVisibleRegion();
            print('Visible region: $bounds');
          }
        },
      ),
    );
  }
}

@visibleForTesting
class HomePageProviders {
  static final mapController =
      StateProvider.autoDispose<GoogleMapController?>((ref) {
    return null;
  });
}

typedef _Providers = HomePageProviders;
