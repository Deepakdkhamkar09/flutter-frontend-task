import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../core/utils/app_loader.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Finding the controller since it's injected via DI
    final UserController controller = Get.find<UserController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.fetchUsers(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // User Creation Form
            const Text(
              'Create New User',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: controller.nameController,
              focusNode: controller.nameFocusNode,
              label: 'Name',
              hint: 'Enter user name',
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: controller.emailController,
              focusNode: controller.emailFocusNode,
              label: 'Email',
              hint: 'Enter user email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            Obx(
              () => CustomButton(
                text: 'Create User',
                onPressed: controller.createUser,
                isLoading: controller.isCreating.value,
              ),
            ),
            const SizedBox(height: 24),

            // Users List Section
            const Text(
              'Users List',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const AppLoader();
                }

                if (controller.errorMessage.value.isNotEmpty &&
                    controller.users.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          controller.errorMessage.value,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: controller.fetchUsers,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.users.isEmpty) {
                  return const Center(
                    child: Text(
                      'No user is available',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: controller.users.length,
                  itemBuilder: (context, index) {
                    final user = controller.users[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            user.name.isNotEmpty
                                ? user.name[0].toUpperCase()
                                : '?',
                          ),
                        ),
                        title: Text(user.name),
                        subtitle: Text(user.email),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
