import 'dart:async';

import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:get/get.dart';
import 'package:new_porto_space/main.dart';
import 'package:nfc_manager/nfc_manager.dart';

class MobileProfileController extends GetxController {
  NfcManager nfcManager = NfcManager.instance;
  RxString result = ''.obs;

  NFCTag? _tag;
  RxString? aResult = ''.obs, _mifareResult = ''.obs;
  late StreamController<bool> _nfcStreamController;
  late Stream<bool> _nfcStream;


  @override
  void onInit() {
    super.onInit();
    _resultStream.listen(
      (data) {
        aResult!.value = data;
        logPink('Result: $data');
      },
    );
    _initializeNfcStream();
  }

  Stream<String> get resultStream => result.stream;
  Stream<String> get _resultStream => aResult!.stream;

  void _initializeNfcStream() {
    _nfcStreamController = StreamController<bool>();
    _nfcStream = _nfcStreamController.stream;

    _nfcStreamController.add(true);

    _nfcStream.listen((_) {
      nfcKit();
    });
  }

  Future<void> nfcKit() async {
    logGreen('TAP THE NFC');
    try {
      NFCTag tag = await FlutterNfcKit.poll();
      _tag = tag;
      await FlutterNfcKit.setIosAlertMessage("Working on it...");
      _mifareResult = null;
      if (tag.standard == "ISO 14443-4 (Type B)") {
        String result1 = await FlutterNfcKit.transceive("00B0950000");
        String result2 = await FlutterNfcKit.transceive("00A4040009A00000000386980701");
        aResult!.value = '1: $result1\n2: $result2\n';
      } else if (tag.type == NFCTagType.iso18092) {
        String result1 = await FlutterNfcKit.transceive("060080080100");
        aResult!.value = '1: $result1\n';
      } else if (tag.ndefAvailable ?? false) {
        var ndefRecords = await FlutterNfcKit.readNDEFRecords();
        var ndefString = '';
        for (int i = 0; i < ndefRecords.length; i++) {
          ndefString += '${i + 1}: ${ndefRecords[i]}\n';
        }
        aResult!.value = ndefString; 
      } else if (tag.type == NFCTagType.webusb) {
        var r = await FlutterNfcKit.transceive("00A4040006D27600012401");
        logCyan(r);
      }
      logCyan('ID: ${_tag!.id}\nStandard: ${_tag!.standard}\nType: ${_tag!.type}\nATQA: ${_tag!.atqa}\nSAK: ${_tag!.sak}\nHistorical Bytes: ${_tag!.historicalBytes}\nProtocol Info: ${_tag!.protocolInfo}\nApplication Data: ${_tag!.applicationData}\nHigher Layer Response: ${_tag!.hiLayerResponse}\nManufacturer: ${_tag!.manufacturer}\nSystem Code: ${_tag!.systemCode}\nDSF ID: ${_tag!.dsfId}\nNDEF Available: ${_tag!.ndefAvailable}\nNDEF Type: ${_tag!.ndefType}\nNDEF Writable: ${_tag!.ndefWritable}\nNDEF Can Make Read Only: ${_tag!.ndefCanMakeReadOnly}\nNDEF Capacity: ${_tag!.ndefCapacity}\nMifare Info:${_tag!.mifareInfo} Transceive Result:\n$aResult\n\nBlock Message:\n$_mifareResult');
    } catch (e) {
      aResult!.value = 'error: $e';
    }

    await FlutterNfcKit.finish(iosAlertMessage: "Finished!");
  }

  @override
  void onClose() {
    super.onClose();
    _nfcStreamController.close();
  }
}
