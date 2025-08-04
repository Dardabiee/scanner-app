import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ocr_app/core/nfc_notifier.dart';
import 'package:provider/provider.dart';

class NfcScanPage extends StatefulWidget {
  const NfcScanPage({super.key});

  @override
  State<NfcScanPage> createState() => _NfcScanPageState();
}

class _NfcScanPageState extends State<NfcScanPage> {
   @override
    void initState() {
      super.initState();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startHandleNfc();
      });
    }
  Future<void> _startHandleNfc() async {
    final nfcNotifier = Provider.of<NfcNotifier>(context, listen: false);
    final bool succes = await nfcNotifier.startNFCOperation(nfcOperation: NFCOperation.read);

    if(mounted){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('NFC scan successful')));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
          Navigator.pop(context);
        }, icon:Icon(Icons.arrow_back)),
      ),
      body: Consumer<NfcNotifier>(
        builder: (context, nfcProvider, child) {
        return SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if(nfcProvider.isProcessing)
              Lottie.asset('assets/icons/Loading.json'),
              if(!nfcProvider.isProcessing)
              Lottie.asset('assets/icons/NFC UNO TAP.json'),
              Text("Tap NFC!", style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),)
            ],
          ),
        );
        }
      ),
    );
  }
}