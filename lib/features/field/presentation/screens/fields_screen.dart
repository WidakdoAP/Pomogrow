import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomogrow/core/theme/palette.dart';
import 'package:pomogrow/core/widgets/back_arrow.dart';
import 'package:pomogrow/core/widgets/global_bottombar.dart';
import 'package:pomogrow/features/field/presentation/providers/field_provider.dart';
import 'package:pomogrow/features/field/presentation/widgets/chart_fields.dart';
import 'package:pomogrow/features/field/presentation/widgets/grid_fields.dart';
import 'package:pomogrow/features/field/presentation/widgets/menu_square.dart';

class FieldsScreen extends StatefulWidget {
  const FieldsScreen({super.key});
  @override
  State<FieldsScreen> createState() => _FieldScreenState();
}

class _FieldScreenState extends State<FieldsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.gradient3,
      bottomNavigationBar: GlobalBottomBar(),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SizedBox(
                        child: Transform.scale(
                          scale: 0.65,
                          child: Transform.translate(
                            offset: const Offset(-20, -70),
                            child: DiagonalGrid(),
                          ),
                        ),
                      ),
                      SizedBox(child: BarChartFields()),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 370,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Consumer(
                  builder: (context, ref, child) {

                    final ownedCountAsync =
                    ref.watch(ownedProductsCountProvider);

                    final plantedCountAsync =
                    ref.watch(plantedCountProvider);

                    return ownedCountAsync.when(
                      loading: () => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Expanded(
                            child: MenuSquare(
                              bigTitle: 'Total',
                              title: '...',
                              desc: 'Hasil fokus mu',
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: MenuSquare(
                              bigTitle: 'Jumlah',
                              title: '...',
                              desc: 'Skin pohon',
                            ),
                          ),
                        ],
                      ),

                      error: (_, _) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Expanded(
                            child: MenuSquare(
                              bigTitle: 'Total',
                              title: '0 / 25',
                              desc: 'Hasil fokus mu',
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: MenuSquare(
                              bigTitle: 'Jumlah',
                              title: '0',
                              desc: 'Skin pohon',
                            ),
                          )
                        ],
                      ),

                      data: (ownedCount) {
                        return plantedCountAsync.when(

                          loading: () => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Expanded(
                                child: MenuSquare(
                                  bigTitle: 'Total',
                                  title: '...',
                                  desc: 'Hasil fokus',
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: MenuSquare(
                                  bigTitle: 'Jumlah',
                                  title: '...',
                                  desc: 'Skin pohon',
                                ),
                              ),
                            ],
                          ),

                          error: (_, _) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: MenuSquare(
                                  bigTitle: 'Total',
                                  title: '0 / 25',
                                  desc: 'Hasil fokus',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: MenuSquare(
                                  bigTitle: 'Jumlah',
                                  title: '$ownedCount',
                                  desc: 'Skin pohon',
                                ),
                              ),
                            ],
                          ),

                          data: (plantedCount) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: MenuSquare(
                                  bigTitle: 'Total',
                                  title: '$plantedCount / 25',
                                  desc: 'Hasil fokus',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: MenuSquare(
                                  bigTitle: 'Jumlah',
                                  title: '$ownedCount',
                                  desc: 'Skin pohon',
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SafeArea(
                  top: true,
                  left: true,
                  child: BackButtonWidgets(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}