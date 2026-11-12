import 'package:shared_preferences/shared_preferences.dart';
import 'base_repository.dart';

class ProfileRepository extends BaseRepository {
  ProfileRepository._();
  static final ProfileRepository instance = ProfileRepository._();

  String userName = '';
  String userAvatar = 'joy';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('userName') ?? '';
    userAvatar = prefs.getString('userAvatar') ?? 'joy';
  }

  @override
  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', userName);
    await prefs.setString('userAvatar', userAvatar);
  }

  void updateProfile(String name, String avatar) {
    userName = name;
    userAvatar = avatar;
    scheduleSave();
  }
}