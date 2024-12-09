import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map_app/providers/charger_spot_provider.dart';
import 'package:flutter_map_app/providers/google_map_provider.dart';
import 'package:flutter_map_app/providers/location_provider.dart';
import 'package:flutter_map_app/providers/markers_provider.dart';
import 'package:flutter_map_app/views/widgets/charger_spot_carousel.dart';
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
    final isMapInitialized = ref.watch(isMapInitializedProvider);

    return GoogleMap(
      initialCameraPosition: initialCameraPosition,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      markers: markers,
      onMapCreated: (GoogleMapController controller) {
        // マップコントローラを状態に保存
        ref.read(mapControllerProvider.notifier).state = controller;
      },
      onCameraIdle: () async {
        if (mapController != null) {
          final bounds = await mapController.getVisibleRegion();
          // 可視範囲の更新
          ref.read(mapBoundsProvider.notifier).updateBounds(bounds);
          // 初回のみ充電スポットの取得とマーカーの更新を実行
          if (!isMapInitialized) {
            // 充電スポットを取得して更新
            await ref
                .read(chargerSpotListProvider.notifier)
                .fetchChargerSpots(bounds);
            // マーカー更新
            final chargerSpots = ref.watch(chargerSpotListProvider);
            await ref
                .read(markerProvider.notifier)
                .updateMarkersFromChargerSpots(chargerSpots);
            // 初期化済みフラグを設定
            ref.read(isMapInitializedProvider.notifier).state = true;
          }
        }
      },
    );
  }
}

class _MyLocationButtonAndCard extends ConsumerWidget {
  const _MyLocationButtonAndCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          child: ChargerSpotCarousel(),
        ),
      ],
    );
  }
}
