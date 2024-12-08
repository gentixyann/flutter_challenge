import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_app/providers/google_map_provider.dart';
import 'package:flutter_map_app/providers/location_provider.dart';
import 'package:flutter_map_app/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyLocationButton extends ConsumerWidget {
  const MyLocationButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.bottomRight,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(55, 55),
          backgroundColor: ThemeColor.darkGray,
          foregroundColor: ThemeColor.white,
          shape: const CircleBorder(),
        ),
        onPressed: () {
          ref.read(_Providers.moveCamera)();
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}

@visibleForTesting
class MyLocationButtonProviders {
  // 位置データを取得し、カメラを移動させるメソッド
  static final moveCamera = Provider.autoDispose((ref) => () async {
        final mapController = ref.watch(mapControllerProvider);
        // 現在地の状態を更新
        ref.read(currentPositionProvider.notifier).state =
            await ref.refresh(locationProvider.future);
        final position = ref.watch(currentPositionProvider);
        final latitude = position?.latitude;
        final longitude = position?.longitude;
        if (latitude == null || longitude == null) {
          return;
        }
        await mapController?.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(latitude, longitude),
              zoom: 14,
            ),
          ),
        );
      });
}

typedef _Providers = MyLocationButtonProviders;
