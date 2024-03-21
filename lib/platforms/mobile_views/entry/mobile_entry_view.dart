import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_porto_space/components/form_text_field.dart';
import 'package:new_porto_space/constant.dart';
import 'package:new_porto_space/platforms/mobile_views/entry/mobile_entry_view_controller.dart';

class MobileEntryView extends GetView<MobileEntryViewController> {
  MobileEntryView({super.key});

  @override
  final MobileEntryViewController controller = Get.put(MobileEntryViewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        ()=> Stack(
          children: [
            Container(
              width: Get.width,
              height: Get.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.white,
                    negativeGrey,
                    positiveColor
                  ],
                  stops: const [1, 0.63, 0.35]
                )
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0, (Get.height - kBottomNavigationBarHeight*2) / Get.height),
              child: controller.loginRegister.value? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () async => await controller.onGoogleLogin(), 
                    child: const AutoSizeText(
                      'Login with Google'
                    )
                  ),
                  ElevatedButton(
                    onPressed: () async => await controller.onAppleLogin(), 
                    child: const AutoSizeText(
                      'Login with Apple'
                    )
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showBottomSheet(
                        context: context,
                        builder: (builderContext) {
                          return Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(8),
                                topLeft: Radius.circular(8),
                              ),
                            ),
                            width: Get.width,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FormTextField(
                                  hintText: 'Email',
                                  controller: controller.emailController,
                                  onSubmitted: (p0) => FocusNode().nextFocus(),
                                ),
                                const SizedBox(height: 8,),
                                FormTextField(
                                  hintText: 'Password',
                                  controller: controller.passwordController,
                                  onSubmitted: (p0) async => await controller.onEmailLogin(controller.emailController.text, controller.passwordController.text),
                                ),
                                const SizedBox(height: 8,),
                                ElevatedButton(
                                  onPressed: () async => await controller.onEmailLogin(controller.emailController.text, controller.passwordController.text),
                                  child: const AutoSizeText(
                                    'Login via Email'
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: const AutoSizeText(
                      'Login with Email',
                    ),
                  )
                ],
              ):
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () async => await controller.onGoogleLogin(), 
                    child: const AutoSizeText(
                      'Sign up with Google'
                    )
                  ),
                  ElevatedButton(
                    onPressed: () async => await controller.onAppleLogin(), 
                    child: const AutoSizeText(
                      'Sign up with Apple'
                    )
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showBottomSheet(
                        context: context, 
                        builder: (builder){
                          return Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(8),
                                topLeft: Radius.circular(8)
                              )
                            ),
                            width: Get.width,
                            child: Column(
                              children: [
                                FormTextField(
                                  hintText: 'Email',
                                  controller: controller.emailController,
                                  onSubmitted: (p0) => FocusNode().nextFocus(),
                                ),
                                const SizedBox(height: 8,),
                                FormTextField(
                                  hintText: 'Password',
                                  controller: controller.passwordController,
                                  onSubmitted: (p0) => FocusNode().nextFocus(),
                                ),
                                const SizedBox(height: 8,),
                                FormTextField(
                                  hintText: 'Confirm Password',
                                  controller: controller.passwordController,
                                  onSubmitted: (p0) async => await controller.onEmailSignUp(
                                    controller.emailController.text, 
                                    controller.passwordController.text,
                                    controller.confirmPasswordController.text
                                  ),
                                ),
                                const SizedBox(height: 8,),
                                ElevatedButton(
                                  onPressed: () async => await controller.onEmailSignUp(
                                    controller.emailController.text, 
                                    controller.passwordController.text,
                                    controller.confirmPasswordController.text
                                  ),
                                  child: const AutoSizeText(
                                    'Sign up via Email'
                                  )
                                )
                              ],
                            ),
                          );
                        }
                      );
                    },
                    child: const AutoSizeText(
                      'Sign up via Email'
                    )
                  )
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => Container(
          height: kBottomNavigationBarHeight,
          width: Get.width,
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextButton(
                  child: AutoSizeText(
                    'Login',
                    style: TextStyle(
                      color: controller.loginRegister.value? positiveColor:negativeGrey
                    ),
                  ),
                  onPressed: ()=>controller.loginRegister.toggle(),
                ),
              ),
              Expanded(
                child: TextButton(
                  child: AutoSizeText(
                    'Register',
                    style: TextStyle(
                      color: controller.loginRegister.value? negativeGrey:positiveColor
                    ),
                  ),
                  onPressed: ()=>controller.loginRegister.toggle(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}