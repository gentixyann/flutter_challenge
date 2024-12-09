import 'package:flutter/material.dart';
import 'package:flutter_map_app/providers/charger_spot_provider.dart';
import 'package:flutter_map_app/providers/location_provider.dart';
import 'package:flutter_map_app/providers/markers_provider.dart';
import 'package:flutter_map_app/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchButton extends ConsumerWidget {
  const SearchButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentBounds = ref.watch(mapBoundsProvider);
    return Container(
      height: 60,
      margin: const EdgeInsets.only(top: 50, left: 15, right: 15),
      child: ElevatedButton(
        onPressed: () async {
          // 再検索時に充電スポットを取得してマーカーを更新
          if (currentBounds != null) {
            // 可視範囲内の充電スポットを取得して更新
            await ref
                .read(chargerSpotListProvider.notifier)
                .fetchChargerSpots(currentBounds);
            // 取得した充電スポットをもとにマーカーを更新
            final chargerSpots = ref.watch(chargerSpotListProvider);
            await ref
                .read(markerProvider.notifier)
                .updateMarkersFromChargerSpots(chargerSpots);
          }
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
