import 'package:get/get.dart';
import 'package:new_porto_space/components/showsnackbar.dart';
import 'package:new_porto_space/main.dart';

abstract class Execute {
  final String instance;

  Execute({required this.instance});
  execute();

  executeWithCatchError(String instance) {
    try {
      execute();
    } catch (error) {
      catchError(instance, error);
    }
  }

  catchError(String instance, dynamic error) {
    logRed("Error in $instance: $error");
    if (Get.isSnackbarOpen) Get.back();
    showSnackBar(
      title: "Error",
      message: "Something went wrong. $error",
      duration: const Duration(seconds: 3),
    );
  }
}
