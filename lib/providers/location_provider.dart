import 'package:flutter_map_app/providers/charger_spot_provider.dart';
import 'package:flutter_map_app/providers/markers_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final tokyoStationLocation = Provider((ref) => const CameraPosition(
      target: LatLng(35.681236, 139.767125),
      zoom: 14,
    ));

final currentPositionProvider = StateProvider<Position?>((ref) => null);

// 現在の位置情報を取得
final locationProvider = FutureProvider((ref) async {
  bool serviceEnabled;
  LocationPermission permission;

  // 位置情報サービスが有効かどうかのテスト
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return null;
  }

  //位置情報サービスのパーミッションチェック
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    //位置情報にアクセスするための許可を促す
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return null;
    }
  }

  //拒否されている場合ここでエラーになる
  if (permission == LocationPermission.deniedForever) {
    return null;
  }

  //許可された場合、位置情報を返す
  ref.read(currentPositionProvider.notifier).state =
      await Geolocator.getCurrentPosition();
  return Geolocator.getCurrentPosition();
});

final mapBoundsProvider =
    StateNotifierProvider<MapBoundsNotifier, LatLngBounds?>((ref) {
  return MapBoundsNotifier(ref);
});

class MapBoundsNotifier extends StateNotifier<LatLngBounds?> {
  final Ref ref;

  MapBoundsNotifier(this.ref) : super(null);

  void updateBounds(LatLngBounds bounds) {
    state = bounds;
  }
}
