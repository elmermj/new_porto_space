import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:get/get.dart';
import 'package:ndef/ndef.dart' as ndef;
import 'package:new_porto_space/main.dart';
import 'package:nfc_manager/nfc_manager.dart';

class MobileProfileController extends GetxController {
  NfcManager nfcManager = NfcManager.instance;
  RxString result = ''.obs;

  NFCAvailability _availability = NFCAvailability.not_supported;
  NFCTag? _tag;
  RxString? _result = ''.obs, _writeResult = ''.obs, _mifareResult = ''.obs;
  List<ndef.NDEFRecord>? _records;
  late StreamController<bool> _nfcStreamController;
  late Stream<bool> _nfcStream;


  @override
  void onInit() {
    super.onInit();
    //apply the resultStream on the page start
    // resultStream.listen(
    //   (data) {
    //     result.value = data;
    //     logPink('Result: $data');
    //   },
    // );
    _resultStream.listen(
      (data) {
        _result!.value = data;
        logPink('Result: $data');
      },
    );
    _initializeNfcStream();
  }

  //make stream to listen to the changes in the value of result
  Stream<String> get resultStream => result.stream;
  Stream<String> get _resultStream => _result!.stream;

  void _initializeNfcStream() {
    _nfcStreamController = StreamController<bool>();
    _nfcStream = _nfcStreamController.stream;

    // Start emitting events immediately
    _nfcStreamController.add(true);

    // Listen to the stream and trigger nfcKit function
    _nfcStream.listen((_) {
      nfcKit();
    });
  }

  Future<void> nfcKit() async {
    logGreen('TAP THE NFC');
    try {
      NFCTag tag = await FlutterNfcKit.poll();
      _tag = tag;
      await FlutterNfcKit.setIosAlertMessage(
          "Working on it...");
      _mifareResult = null;
      if (tag.standard == "ISO 14443-4 (Type B)") {
        String result1 = await FlutterNfcKit.transceive("00B0950000");
        String result2 = await FlutterNfcKit.transceive(
            "00A4040009A00000000386980701");
        _result!.value = '1: $result1\n2: $result2\n';
      } else if (tag.type == NFCTagType.iso18092) {
        String result1 = await FlutterNfcKit.transceive("060080080100");
          _result!.value = '1: $result1\n';
      } else if (tag.ndefAvailable ?? false) {
        var ndefRecords = await FlutterNfcKit.readNDEFRecords();
        var ndefString = '';
        for (int i = 0; i < ndefRecords.length; i++) {
          ndefString += '${i + 1}: ${ndefRecords[i]}\n';
        }
        _result!.value = ndefString; 
      } else if (tag.type == NFCTagType.webusb) {
        var r = await FlutterNfcKit.transceive(
            "00A4040006D27600012401");
        logCyan(r);
      }
      logCyan('ID: ${_tag!.id}\nStandard: ${_tag!.standard}\nType: ${_tag!.type}\nATQA: ${_tag!.atqa}\nSAK: ${_tag!.sak}\nHistorical Bytes: ${_tag!.historicalBytes}\nProtocol Info: ${_tag!.protocolInfo}\nApplication Data: ${_tag!.applicationData}\nHigher Layer Response: ${_tag!.hiLayerResponse}\nManufacturer: ${_tag!.manufacturer}\nSystem Code: ${_tag!.systemCode}\nDSF ID: ${_tag!.dsfId}\nNDEF Available: ${_tag!.ndefAvailable}\nNDEF Type: ${_tag!.ndefType}\nNDEF Writable: ${_tag!.ndefWritable}\nNDEF Can Make Read Only: ${_tag!.ndefCanMakeReadOnly}\nNDEF Capacity: ${_tag!.ndefCapacity}\nMifare Info:${_tag!.mifareInfo} Transceive Result:\n$_result\n\nBlock Message:\n$_mifareResult');
    } catch (e) {
      _result!.value = 'error: $e';
    }

    // Pretend that we are working
    await FlutterNfcKit.finish(iosAlertMessage: "Finished!");
  }

  @override
  void onClose() {
    super.onClose();
    _nfcStreamController.close(); // Close the stream controller when the controller is disposed
  }
}
