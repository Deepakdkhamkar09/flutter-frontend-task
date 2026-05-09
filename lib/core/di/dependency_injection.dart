import 'package:get/get.dart';
import '../api/api_client.dart';
import '../../repositories/user_repository.dart';
import '../../controllers/user_controller.dart';

class DependencyInjection {
  static void init() {
    // API Client
    Get.lazyPut<ApiClient>(() => ApiClient(), fenix: true);

    // Repositories
    Get.lazyPut<UserRepository>(() => UserRepository(Get.find<ApiClient>()), fenix: true);

    // Controllers
    Get.lazyPut<UserController>(() => UserController(Get.find<UserRepository>()), fenix: true);
  }
}
