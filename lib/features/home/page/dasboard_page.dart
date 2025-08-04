import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ocr_app/core/nfc_notifier.dart';
import 'package:ocr_app/features/finger_print/presentation/page/fingerprint_page.dart';
import 'package:ocr_app/features/home/widget/card_button_widget.dart';
import 'package:ocr_app/features/home/widget/scan_button_widget.dart';
import 'package:ocr_app/features/mrz_scanner/presentation/pages/mrz_scanner_page.dart';
import 'package:local_auth/local_auth.dart';
import 'package:ocr_app/features/nfc_reader/nfc_scan_page.dart';
import 'package:provider/provider.dart';

class DasboardPage extends StatefulWidget {
  const DasboardPage({super.key});

  @override
  State<DasboardPage> createState() => _DasboardPageState();
}

class _DasboardPageState extends State<DasboardPage> {
  final LocalAuthentication _auth = LocalAuthentication();
  bool _isAlreadyPrint = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    
                  },
                  child: Container(        
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 242, 240, 240),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color.fromARGB(255, 214, 214, 214),
                        width: 1
                      )
                    ),
                    child: Icon(Icons.notifications),
                  ),
                ),
                SizedBox(width: 5,),
                GestureDetector(
                  onTap: () {
                    
                  },
                  child: Container(        
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 242, 240, 240),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color.fromARGB(255, 214, 214, 214),
                        width: 1
                      )
                    ),
                    child: Icon(Icons.person),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 242, 240, 240) ,
        child: ListView(
          
        ),
      ),
      body: ChangeNotifierProvider(
        create: (context) => NfcNotifier(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 110,),
                Text("Hi Kannan", 
                style:  TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold
                ),),
                SizedBox(height: 1,),
                Text("What are we\nscanning today?",             
                style:
                TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  height: 1
                ),),
                SizedBox(height: 15,),
                ScanCard(press: () { 
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MrzScannerPage()));
                 },),
                SizedBox(height: 20,),
                Row(
                  children: [
                  CardButton(
                        title: "Fingerprint", 
                        icon: 'assets/icons/ic_outline-fingerprint.svg', 
                        color: Colors.purple.shade100, press: () async{
                          if(!_isAlreadyPrint){
                                      try{
                                        final bool canAuthenticateWithBiometric = await _auth.canCheckBiometrics;
                                        final bool isDeviceSupported = await _auth.isDeviceSupported();
                                        print("Can authenticate: $canAuthenticateWithBiometric | Supported: $isDeviceSupported");
        
                                        if(canAuthenticateWithBiometric && isDeviceSupported){
                                          final bool didAuthenticate = await  _auth.authenticate(localizedReason: "Please authenticate to move next page",
                                          options: const AuthenticationOptions(
                                             biometricOnly: true,
                                             stickyAuth: true,
                                             useErrorDialogs: true,
                                           )
                                          );
                                           print("Authenticated: $didAuthenticate");
                                          if(didAuthenticate){
                                          setState(() {
                                            _isAlreadyPrint = true;                       
                                          });
                                           Navigator.push(context, MaterialPageRoute(builder: (context) => FingerprintPage()));
                                          }else{
                                             print("Fingerprint not matched or cancelled");
                                          }
                                        }else{
                                           print("Device not supported or no biometric enrolled");
                                        }
                                      }catch(e){
                                        print(e);
                                      }
                                    }else{
                                      _isAlreadyPrint = false;
                            }
                        }
                    ),
                  SizedBox(width: 20,),
                  CardButton(
                    title: "Read NFC",
                    icon: "assets/icons/tabler_nfc.svg",
                    color: Colors.orange.shade100,
                    press: () async {
                      Provider.of<NfcNotifier>(context, listen: false).startNFCOperation(nfcOperation: NFCOperation.read);
      
                      // final bool succes = await 
                      Navigator.push(context, MaterialPageRoute(builder: (context) => NfcScanPage()));

                      // if(succes){
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(content: Text('NFC Tag berhasil dibaca!')),
                      //   );
                      // }else{
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(content: Text('Operasi NFC gagal')),
                      //   );
                      // }
                    },
                   ),
                  ],
                ),
                Consumer<NfcNotifier>(
                  builder: (context, provider, _) {
                    return provider.isProcessing
                      ? Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: CircularProgressIndicator(),
                        )
                      : SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
