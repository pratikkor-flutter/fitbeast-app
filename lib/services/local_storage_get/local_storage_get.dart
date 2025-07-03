import 'package:fitbeast/core/constants/app_constants.dart';
import 'package:get_storage/get_storage.dart';

class LocalStorageGet {
  static final GetStorage _storage = GetStorage();

  Future<void> setOnboardingComplete() async {
    await _storage.write(LocalStorageKeys.onboardingKey, true);
  }

  Future<void> setName(List<String> name) async {
    await _storage.write(LocalStorageKeys.name, name);
  }

  Future<void> setPostRegOnboardingComplete() async {
    await _storage.write(LocalStorageKeys.postRegOnboardingKey, true);
  }

  Future<void> setUserLoggedInStatus(bool status) async {
    await _storage.write(LocalStorageKeys.userLoginKey, status);
  }

  Future<void> clearUserData() async {
    await _storage.remove(LocalStorageKeys.onboardingKey);
    await _storage.remove(LocalStorageKeys.name);
    await _storage.remove(LocalStorageKeys.postRegOnboardingKey);
    await _storage.remove(LocalStorageKeys.userLoginKey);
  }
}
