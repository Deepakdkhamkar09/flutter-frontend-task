import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';
import '../core/utils/app_snackbar.dart';

class UserController extends GetxController {
  final UserRepository _userRepository;

  UserController(this._userRepository);

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final nameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();

  final RxList<UserModel> users = <UserModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isCreating = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    nameFocusNode.dispose();
    emailFocusNode.dispose();
    super.onClose();
  }

  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final fetchedUsers = await _userRepository.getUsers();
      users.assignAll(fetchedUsers);
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      AppSnackbar.showError('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createUser() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();

    if (name.isEmpty || email.isEmpty) {
      AppSnackbar.showError(
        'Validation Error',
        'Please enter both name and email',
      );
      return;
    }

    try {
      isCreating.value = true;
      final user = UserModel(name: name, email: email);

      await _userRepository.createUser(user);

      AppSnackbar.showSuccess('Success', 'User created successfully');

      nameFocusNode.unfocus();
      emailFocusNode.unfocus();
      nameController.clear();
      emailController.clear();

      // Refresh list
      fetchUsers();
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '');
      AppSnackbar.showError('Error', msg);
    } finally {
      isCreating.value = false;
    }
  }
}
