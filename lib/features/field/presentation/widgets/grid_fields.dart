import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

import 'package:pomogrow/features/field/presentation/providers/field_provider.dart';

class DiagonalGrid extends ConsumerWidget {
  const DiagonalGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tilesAsync = ref.watch(fieldTilesProvider);
    final getImageUrl = ref.watch(getImageUrlProvider);

    return Center(
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.00001) // perspective depth
          ..rotateX(0.9) // tilt forward 2.5D Bisa 0.9, 1, 2 yang pas
          ..rotateZ(math.pi / 4), // optional rotate 45° like farmland
        alignment: Alignment.center,
        child: SizedBox(
          width: 500,
          height: 500,
          child: tilesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text("Error: $e")),
            data: (tiles) {
              final tilesMap = {for (var t in tiles) t.tileIndex: t};
              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: 1,
                ),
                itemCount: 25,
                itemBuilder: (context, index) {
                  final tile = tilesMap[index];
                  final plantUrl = tile == null
                      ? ""
                      : getImageUrl(tile.plantImage);

                  return Stack(
                    children: [
                      Positioned.fill(
                        child: Transform(
                          transform: Matrix4.identity()
                            ..rotateZ(-math.pi / 4)
                            ..rotateX(-0.9),
                          alignment: Alignment.center,
                          child: Image.asset(
                            "assets/images/soil.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      if (plantUrl.isNotEmpty)
                        Positioned.fill(
                          child: Transform.scale(
                            scale: 2,
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..rotateX(-0.009)
                                ..rotateZ(-math.pi / 4),
                              child: Transform.translate(
                                offset: const Offset(0, -20), // naik 10 pixel
                                child: Image.network(
                                  plantUrl,
                                  width: 120, // ukuran pohon
                                  height: 120,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

// return Container(
//                   alignment: Alignment.center,
//                   decoration: BoxDecoration(
//                     color: Colors.green[500],
//                     border: Border.all(color: Colors.white, width: 1),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 );

                // return Transform(
                //   transform: Matrix4.identity()
                //     ..rotateZ(-math.pi / 4) // undo rotateZ for each tile
                //     ..rotateX(-0.9), // undo rotateX for each tile
                //   alignment: Alignment.center,
                //   child: Image.asset("assets/images/soil.png", fit: BoxFit.cover),
                // );


                // return Transform(
                //   transform: Matrix4.identity()
                //     ..rotateZ(-math.pi / 4) // undo rotateZ for each tile
                //     ..rotateX(-0.9), // undo rotateX for each tile
                //   alignment: Alignment.center,
                //   child: ClipRRect(
                //     borderRadius: BorderRadius.circular(10),
                //     child: Container(
                //       decoration: BoxDecoration(
                //         image: DecorationImage(
                //           image: AssetImage("assets/images/soil.png"),
                //           fit: BoxFit.cover,
                //         ),
                //       ),
                //     ),
                //   ),
                // );
