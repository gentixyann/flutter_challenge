import 'package:flutter/material.dart';
import 'package:flutter_map_app/providers/google_map_provider.dart';
import 'package:flutter_map_app/providers/location_provider.dart';
import 'package:flutter_map_app/providers/markers_provider.dart';
import 'package:flutter_map_app/views/widgets/charger_spot_card.dart';
import 'package:flutter_map_app/views/widgets/my_location_button.dart';
import 'package:flutter_map_app/views/widgets/search_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref.watch(locationProvider).when(
            data: (position) {
              // 位置情報が取得できない場合、東京駅をデフォルト位置に設定
              final initialCameraPosition = position != null
                  ? CameraPosition(
                      target: LatLng(position.latitude, position.longitude),
                      zoom: 14,
                    )
                  : ref.watch(tokyoStationLocation);
              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  _GoogleMap(initialCameraPosition: initialCameraPosition),
                  const SearchButton(),
                  const _MyLocationButtonAndCard(),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Text('位置情報を取得できません: $error'),
            ),
          ),
    );
  }
}

class _GoogleMap extends ConsumerWidget {
  final CameraPosition initialCameraPosition;

  const _GoogleMap({
    required this.initialCameraPosition,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapController = ref.watch(mapControllerProvider);
    final markers = ref.watch(markerProvider);

    return GoogleMap(
      initialCameraPosition: initialCameraPosition,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      markers: markers,
      onMapCreated: (GoogleMapController controller) async {
        // マップコントローラを状態に保存
        ref.read(mapControllerProvider.notifier).state = controller;
        final bounds = await controller.getVisibleRegion();
        // 可視範囲を更新
        ref.read(mapBoundsProvider.notifier).updateBounds(bounds);
        // 充電スポットを再取得しマーカーを表示
        ref.read(markerProvider.notifier).searchSpots(ref: ref, bounds: bounds);
      },
      onCameraIdle: () async {
        if (mapController != null) {
          final bounds = await mapController.getVisibleRegion();
          ref.read(mapBoundsProvider.notifier).updateBounds(bounds);
        }
      },
    );
  }
}

class _MyLocationButtonAndCard extends ConsumerWidget {
  const _MyLocationButtonAndCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          MyLocationButton(),
          SizedBox(height: 20),
          ChargerSpotCard(),
        ],
      ),
    );
  }
}
