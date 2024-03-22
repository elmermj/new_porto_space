import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:new_porto_space/platforms/mobile_views/profile/mobile_profile_controller.dart';
import 'package:rive/rive.dart' as rive;

class MobileVerifyProfileView extends GetView<MobileProfileController> {
  MobileVerifyProfileView({super.key});

  @override
  final MobileProfileController controller = Get.put(MobileProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Profile'),
        centerTitle: true,
        backgroundColor: Colors.grey[900],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Get.back();
          }
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: Get.height,
              width: Get.width,
              color: Colors.grey[900],
            ),
            Center(
              child: SizedBox(
                height: Get.height*0.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(
                      flex: 4,
                      child: Center(
                        child: rive.RiveAnimation.asset(
                          "assets/animation/card_swipe.riv", 
                          fit: BoxFit.contain, 
                          alignment: Alignment.bottomCenter,
                        )
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          controller.nfcKit();
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: Get.width*0.1, vertical: 0),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 24,24,24),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Center(
                            child: AutoSizeText(
                              'Tap your national ID card on the back of your phone to verify your profile.\n Currently only those who has a valid Indonesian ID can use this feature. \n Your device must support NFC to use this feature. \nTap here to scan',
                              maxLines: 10,
                              textAlign: TextAlign.center,
                              minFontSize: 10,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              )
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}