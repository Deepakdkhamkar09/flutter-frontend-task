import '../models/user_model.dart';
import '../core/api/api_client.dart';
import '../core/api/api_constants.dart';

class UserRepository {
  final ApiClient _apiClient;

  UserRepository(this._apiClient);

  Future<List<UserModel>> getUsers() async {
    try {
      final response = await _apiClient.get(ApiConstants.users);
      if (response is Map<String, dynamic>) {
        if (response['success'] == true || response['success'] == "true") {
          final data = response['data'];
          if (data is List) {
            return data
                .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
                .toList();
          }
        } else {
          throw Exception(response['message'] ?? 'Failed to fetch users');
        }
      } else if (response is List) {
        return response
            .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> createUser(UserModel user) async {
    try {
      final response = await _apiClient.post(ApiConstants.users, user.toJson());
      if (response is Map<String, dynamic>) {
        if (response['success'] == true || response['success'] == "true") {
          return true;
        } else {
          throw Exception(response['message'] ?? 'Failed to create user');
        }
      }
      return true; // Assume success if no error and no standard format
    } catch (e) {
      rethrow;
    }
  }
}
