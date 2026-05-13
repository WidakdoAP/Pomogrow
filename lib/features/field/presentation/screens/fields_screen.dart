import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomogrow/core/theme/palette.dart';
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
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      SizedBox(
                        child: Transform.scale(
                          scale: 0.65,
                          child: Transform.translate(
                            offset: const Offset(0, -70),
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
                    final countAsync = ref.watch(plantedCountProvider);

                    return countAsync.when(
                      loading: () => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          MenuSquare(
                            bigTitle: 'Total',
                            title: '...',
                            desc: 'Hasil fokus mu',
                          ),
                          MenuSquare(
                            bigTitle: 'Jumlah',
                            title: '1',
                            desc: 'Skin pohon mu',
                          ),
                        ],
                      ),

                      data: (count) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MenuSquare(
                            bigTitle: 'Total',
                            title: '$count / 25',
                            desc: 'Hasil fokus mu',
                          ),
                          const MenuSquare(
                            bigTitle: 'Jumlah',
                            title: '1',
                            desc: 'Skin pohon mu',
                          ),
                        ],
                      ),

                      error: (e, _) => Text("Error: $e"),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
