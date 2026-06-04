import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class RiveTreeService {
  Artboard? artboard;
  SMIInput<double>? progress;

  Future<void> load() async {
    if (artboard != null) return;

    final data = await rootBundle.load('assets/animations/tree.riv');

    await RiveFile.initialize();
    final file = RiveFile.import(data);
    final board = file.mainArtboard;
    final controller =
    StateMachineController.fromArtboard(board, 'State Machine 1');

    if (controller != null) {
      board.addController(controller);

      progress = controller.findInput<double>('input');

      artboard = board;
    }
  }
}