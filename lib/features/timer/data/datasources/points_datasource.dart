import 'package:supabase_flutter/supabase_flutter.dart';

class PointsDatasource {
  final supabase = Supabase.instance.client;

  Future<void> addPoints(int minutes) async {
    // This user.
    final user = supabase.auth.currentUser;
    // if there's no user return.
    if (user == null) return;

    // Get current points.
    final response = await supabase
        .from('user_profiles')
        .select('points')
        .eq('id', user.id)
        .single();

    final currentPoints = int.tryParse(response['points'].toString()) ?? 0;

    // Taken from the minute that the user has chosen.
    final newPoints = currentPoints + minutes;

    await supabase
        .from('user_profiles')
        .update({'points': newPoints})
        .eq('id', user.id);
  }
}