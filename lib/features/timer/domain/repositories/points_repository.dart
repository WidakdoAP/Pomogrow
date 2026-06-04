abstract class PointsRepository {
  Future<void> addPoints(int minutes);
  Future<void> incrementFocusStat(int index);
}