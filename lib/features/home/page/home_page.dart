import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ocr_app/core/nfc_notifier.dart';
import 'package:ocr_app/features/finger_print/presentation/page/fingerprint_page.dart';
import 'package:ocr_app/features/home/page/dasboard_page.dart';
import 'package:ocr_app/features/home/widget/card_button_widget.dart';
import 'package:ocr_app/features/home/widget/scan_button_widget.dart';
import 'package:ocr_app/features/mrz_scanner/presentation/pages/mrz_scanner_page.dart';
import 'package:local_auth/local_auth.dart';
import 'package:ocr_app/features/nfc_reader/nfc_scan_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  int _currentIndex = 0;
  final List<Widget> _getScreen = [
  DasboardPage(),
  MrzScannerPage(),
  FingerprintPage(),
  NfcScanPage(),
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getScreen[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
         BottomNavigationBarItem(icon: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Icon(Icons.home, size: 35,),
          ), label: 'Home'),
        BottomNavigationBarItem(icon: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: SvgPicture.asset('assets/icons/material-symbols_scan-outline-rounded.svg',width: 35, height: 35, fit: BoxFit.cover ),
          ), label: 'Scan'),
          BottomNavigationBarItem(icon: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: SvgPicture.asset( 'assets/icons/ic_outline-fingerprint.svg',width: 35, height: 35, fit: BoxFit.cover ),
          ), label: 'Fingerprint'),
          BottomNavigationBarItem(icon: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: SvgPicture.asset( "assets/icons/tabler_nfc.svg",width: 35, height: 35, fit: BoxFit.cover ),
          ), label: 'NFC'),
      ]),
    );
  }
}