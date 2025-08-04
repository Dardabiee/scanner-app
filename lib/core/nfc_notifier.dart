import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:ndef/ndef.dart';
import 'package:ocr_app/features/nfc_reader/nfc_scan_page.dart';

class NfcNotifier extends ChangeNotifier {
  bool _isProcessing = false;
  String _message = "";

  bool get isProcessing => _isProcessing;
  String get message => _message;

  Future<bool> startNFCOperation ({ required NFCOperation nfcOperation}) async {
    final completer = Completer<bool>();
    try{
      _isProcessing = true;
      notifyListeners();

      bool isAvail = await NfcManager.instance.isAvailable();
      if(isAvail){

        if(nfcOperation == NFCOperation.read){
          _message = "Reading NFC Tag";
        }
        notifyListeners();

        NfcManager.instance.startSession(
        pollingOptions: {
          NfcPollingOption.iso14443,
          NfcPollingOption.iso15693,
          NfcPollingOption.iso18092,
        },
        onDiscovered: (NfcTag nfcTag) async {
          try{
            if(nfcOperation == NFCOperation.read){
              _readFromTag(tag: nfcTag);
              completer.complete(true);
            }
            _isProcessing = false;
            notifyListeners();
            await NfcManager.instance.stopSession();

            }catch(e){ 
              _isProcessing = false;
              _message = e.toString();
              completer.complete(false);
              notifyListeners();
            }
          });

      }else{
        _isProcessing = false;
        _message = "Please enable NFC on your device";
        completer.complete(false);
        notifyListeners();
      }

    }catch(e){
      _isProcessing = false;
      _message = e.toString();
      completer.complete(false);
      notifyListeners();
    }
     return completer.future; 
  }

  Future<void> _readFromTag({required NfcTag tag}) async {
    Map<String, dynamic> nfcData = {
      'nfca': tag.data,
      'mifareultrahigh': tag.data,
      'ndef': tag.data
    };
    String? decodedText;
    if(nfcData.containsKey("ndef")){
      List<int> payload = nfcData['ndef']['cachedMessage']?['records']?[0]['payload'];
      decodedText = String.fromCharCodes(payload);
    }
    _message = decodedText ?? "No data found";
  }
}

enum NFCOperation{
  read;
}