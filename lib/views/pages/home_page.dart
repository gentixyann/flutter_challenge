import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_app/charger_spot.dart';
import 'package:flutter_map_app/charger_spots_repository.dart';
import 'package:flutter_map_app/providers/charger_spot_provider.dart';
import 'package:flutter_map_app/providers/google_map_provider.dart';
import 'package:flutter_map_app/providers/location_provider.dart';
import 'package:flutter_map_app/providers/markers_provider.dart';
import 'package:flutter_map_app/theme.dart';
import 'package:flutter_map_app/views/widgets/charger_spot_card.dart';
import 'package:flutter_map_app/views/widgets/my_location_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 可視範囲の状態を監視
    final currentBounds = ref.watch(mapBoundsProvider);

    // 可視範囲に基づいて充電スポットを取得
    if (currentBounds != null) {
      ref.listen<AsyncValue<GetChargerSpotsResponse>>(
        chargerSpotsProvider(currentBounds),
        (previous, next) {
          next.when(
            loading: () => print("Loading charger spots..."),
            error: (error, stack) =>
                print("Error loading charger spots: $error"),
            data: (response) {
              // MarkerNotifier のメソッドでマーカーを更新
              ref
                  .read(markerProvider.notifier)
                  .updateMarkersFromResponse(response);
            },
          );
        },
      );
    }

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
                  const _SearchButton(),
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

class _SearchButton extends ConsumerWidget {
  const _SearchButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 60,
      margin: const EdgeInsets.only(top: 50, left: 15, right: 15),
      child: ElevatedButton(
        onPressed: () {
          print('再検索');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeColor.lightGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(34),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'このエリアでスポット検索',
              style: TextStyle(
                color: ThemeColor.green,
              ),
            ),
            Icon(
              Icons.search,
              color: ThemeColor.green,
            ),
          ],
        ),
      ),
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

// @visibleForTesting
// class HomePageProviders {
//   // 位置データを取得し、カメラを移動させるメソッド
//   static final moveCamera = Provider.autoDispose((ref) => () async {
//         print('moveCamera');
//         final mapController = ref.watch(_Providers.mapController);
//         // 現在地の状態を更新
//         ref.read(currentPositionProvider.notifier).state =
//             await ref.refresh(locationProvider.future);
//         final position = ref.watch(currentPositionProvider);
//         final latitude = position?.latitude;
//         final longitude = position?.longitude;
//         if (latitude == null || longitude == null) {
//           return;
//         }
//         print(position);
//         await mapController?.moveCamera(
//           CameraUpdate.newCameraPosition(
//             CameraPosition(
//               target: LatLng(latitude, longitude),
//               zoom: 14,
//             ),
//           ),
//         );
//       });
// }

// typedef _Providers = HomePageProviders;
