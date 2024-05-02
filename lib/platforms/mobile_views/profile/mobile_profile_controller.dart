import 'dart:async';

// import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:get/get.dart';
import 'package:new_porto_space/main.dart';
import 'package:nfc_manager/nfc_manager.dart';

class MobileProfileController extends GetxController {
  NfcManager nfcManager = NfcManager.instance;
  RxString result = ''.obs;

  // NFCTag? tag;
  RxString? aResult = ''.obs;
  // RxString? mifareResult = ''.obs;
  late StreamController<bool> nfcStreamController;
  late Stream<bool> nfcStream;


  @override
  void onInit() {
    super.onInit();
    aResultStream.listen(
      (data) {
        aResult!.value = data;
        logPink('Result: $data');
      },
    );
    initializeNfcStream();
  }

  Stream<String> get resultStream => result.stream;
  Stream<String> get aResultStream => aResult!.stream;

  void initializeNfcStream() {
    nfcStreamController = StreamController<bool>();
    nfcStream = nfcStreamController.stream;

    nfcStreamController.add(true);

    nfcStream.listen((_) {
      nfcKit();
    });
  }

  Future<void> nfcKit() async {
    logGreen('TAP THE NFC');
    // try {
    //   NFCTag nfctag = await FlutterNfcKit.poll();
    //   tag = nfctag;
    //   await FlutterNfcKit.setIosAlertMessage("Working on it...");
    //   _mifareResult = null;
    //   if (tag.standard == "ISO 14443-4 (Type B)") {
    //     String result1 = await FlutterNfcKit.transceive("00B0950000");
    //     String result2 = await FlutterNfcKit.transceive("00A4040009A00000000386980701");
    //     aResult!.value = '1: $result1\n2: $result2\n';
    //   } else if (tag.type == NFCTagType.iso18092) {
    //     String result1 = await FlutterNfcKit.transceive("060080080100");
    //     aResult!.value = '1: $result1\n';
    //   } else if (tag.ndefAvailable ?? false) {
    //     var ndefRecords = await FlutterNfcKit.readNDEFRecords();
    //     var ndefString = '';
    //     for (int i = 0; i < ndefRecords.length; i++) {
    //       ndefString += '${i + 1}: ${ndefRecords[i]}\n';
    //     }
    //     aResult!.value = ndefString; 
    //   } else if (tag.type == NFCTagType.webusb) {
    //     var r = await FlutterNfcKit.transceive("00A4040006D27600012401");
    //     logCyan(r);
    //   }
    //   logCyan('ID: ${tag!.id}\nStandard: ${tag!.standard}\nType: ${tag!.type}\nATQA: ${tag!.atqa}\nSAK: ${tag!.sak}\nHistorical Bytes: ${tag!.historicalBytes}\nProtocol Info: ${tag!.protocolInfo}\nApplication Data: ${tag!.applicationData}\nHigher Layer Response: ${tag!.hiLayerResponse}\nManufacturer: ${tag!.manufacturer}\nSystem Code: ${tag!.systemCode}\nDSF ID: ${tag!.dsfId}\nNDEF Available: ${tag!.ndefAvailable}\nNDEF Type: ${tag!.ndefType}\nNDEF Writable: ${tag!.ndefWritable}\nNDEF Can Make Read Only: ${tag!.ndefCanMakeReadOnly}\nNDEF Capacity: ${tag!.ndefCapacity}\nMifare Info:${tag!.mifareInfo} Transceive Result:\n$aResult\n\nBlock Message:\n$mifareResult');
    // } catch (e) {
    //   aResult!.value = 'error: $e';
    // }

    // await FlutterNfcKit.finish(iosAlertMessage: "Finished!");
  }

  @override
  void onClose() {
    super.onClose();
    nfcStreamController.close();
  }
}
