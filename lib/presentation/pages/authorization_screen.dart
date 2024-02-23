import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_service/data/auth/authorization_manager.dart';
import 'package:weather_service/presentation/pages/weather_screen.dart';

// контроллер состояния поля с паролем
class PasswordFieldStateController extends GetxController {
  RxBool isVisible = false.obs;
  changeState() => isVisible.value = !isVisible.value;
}

// экран авторизации
// ignore: must_be_immutable
class AuthorizationPageScreen extends StatelessWidget {
  AuthorizationPageScreen({super.key});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final PasswordFieldStateController _passwordFieldStateController =
      Get.put(PasswordFieldStateController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(27.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            Text(
              "Вход",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              "Введите данные для входа",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(label: Text("Email")),
            ),
            Obx(() => TextField(
                  controller: _passwordController,
                  obscureText: !_passwordFieldStateController.isVisible.value,
                  decoration: InputDecoration(
                      label: const Text("Пароль"),
                      suffixIcon: IconButton(
                          onPressed: () {
                            _passwordFieldStateController.changeState();
                          },
                          icon: !_passwordFieldStateController.isVisible.value
                              ? Icon(
                                  Icons.visibility,
                                  color: Theme.of(context).primaryColor,
                                )
                              : Icon(
                                  Icons.visibility_off,
                                  color: Theme.of(context).primaryColor,
                                ))),
                )),
            const SizedBox(
              height: 32,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () async {
                    bool success = false;
                    try {
                      // пытаеся залогиниться
                      success = await AuthorizationManager().authenticate(
                          _emailController.text, _passwordController.text);
                    } on FirebaseAuthExceptionWithMessage catch (error) {
                      // если не получается по известной нам ошибке - выводим сообщение в диалоге
                      showDialog(
                          context: context,
                          builder: (__) => AlertDialog(
                                title: const Text("Внимание"),
                                content: Text(error.message),
                                actions: [
                                  TextButton(
                                      onPressed: Get.back,
                                      child: const Text("Понятно"))
                                ],
                              ));
                      return;
                    }

                    if (!success) {
                      // если не получилось залогиниться потому что пользователя нет - показываем диалог с предложением создать аккаунт
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                                title: const Text("Внимание"),
                                content: const Text(
                                    "Пользователь с предоставленными данными не найден, хотите создать аккаунт с этими данными?"),
                                actions: [
                                  TextButton(
                                      onPressed: Get.back,
                                      child: const Text("Нет")),
                                  TextButton(
                                      onPressed: () async {
                                        Get.back();
                                        bool create_success = false;
                                        try {
                                          create_success =
                                              await AuthorizationManager()
                                                  .createNewUser(
                                                      _emailController.text,
                                                      _passwordController.text);
                                        } on FirebaseAuthExceptionWithMessage catch (error) {
                                          // обрабатываем известные ошибки при создании аккаунта
                                          showDialog(
                                              context: context,
                                              builder: (__) => AlertDialog(
                                                    title:
                                                        const Text("Внимание"),
                                                    content:
                                                        Text(error.message),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: Get.back,
                                                          child: const Text(
                                                              "Понятно"))
                                                    ],
                                                  ));
                                          return;
                                        }
                                        if (!create_success) {
                                          // если не получилось создать аккаунт - просим проверить данные
                                          showDialog(
                                              context: context,
                                              builder: (__) => AlertDialog(
                                                    title:
                                                        const Text("Внимание"),
                                                    content: const Text(
                                                        "Проверьте корректность введенных данных!"),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: Get.back,
                                                          child: const Text(
                                                              "Понятно"))
                                                    ],
                                                  ));
                                          return;
                                        }
                                        // если все хорошо - переходим на экран с погодой
                                        Get.off(() => WeatherPageScreen(),
                                            transition: Transition.fadeIn);
                                      },
                                      child: const Text("Да"))
                                ],
                              ));
                      return;
                    }
                    Get.off(() => WeatherPageScreen(),
                        transition: Transition.fadeIn);
                  },
                  child: const Text("Войти")),
            ),
          ],
        ),
      ),
    );
  }
}
