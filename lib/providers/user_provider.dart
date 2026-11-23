import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';

final userListProvider =
    AsyncNotifierProvider<UserNotifier, List<UserModel>>(() {
  return UserNotifier();
});

class UserNotifier extends AsyncNotifier<List<UserModel>> {
  final StorageService _storage = StorageService();

  @override
  Future<List<UserModel>> build() async {
    return await _storage.loadUsers();
  }

  Future<void> addUser(UserModel user) async {
    final currentList = state.value ?? [];
    final updatedList = [...currentList, user];
    state = AsyncData(updatedList);
    await _storage.saveUsers(updatedList);
  }

  Future<void> updateUser(UserModel updatedUser) async {
    final currentList = state.value ?? [];
    final updatedList = currentList.map((user) {
      return user.id == updatedUser.id ? updatedUser : user;
    }).toList();
    state = AsyncData(updatedList);
    await _storage.saveUsers(updatedList);
  }

  Future<void> deleteUser(String id) async {
    final currentList = state.value ?? [];
    final updatedList = currentList.where((user) => user.id != id).toList();
    state = AsyncData(updatedList);
    await _storage.saveUsers(updatedList);
  }
}
