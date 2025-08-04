import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ocr_app/features/mrz_scanner/presentation/pages/result_scanner_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class MrzScannerPage extends StatefulWidget {
  const MrzScannerPage({super.key});

  @override
  State<MrzScannerPage> createState() => _MrzScannerPageState();
}

class _MrzScannerPageState extends State<MrzScannerPage> with WidgetsBindingObserver {
  String _mrzData = "";
  bool _isPermissionGranted = false;
  late final Future<void> _future;
  CameraController?  _cameraController;
  final _textRecognizer = TextRecognizer();

  @override
  void initState(){
    super.initState();
     WidgetsBinding.instance.addObserver(this);
    _future = checkPermission();
   
  }

  @override
 void dispose(){
  WidgetsBinding.instance.removeObserver(this);
  _stopCamera();
  _textRecognizer.close();
  super.dispose();
 }

  
  
  void _startCamera(){
    if(_cameraController != null){
      _cameraSelected(_cameraController!.description);
    }
  }

  void _stopCamera(){
    if(_cameraController == null){
      _cameraController?.dispose();
    }
  }


  Future<void> checkPermission() async {
    final status = await Permission.camera.request();
    _isPermissionGranted = status == PermissionStatus.granted;
  }

  void _initCameraController(List<CameraDescription> cameras) async {
    if(_cameraController != null){
      return;
    }

    CameraDescription? camera;
    for(var i = 0; i < cameras.length; i++){
      final CameraDescription current = cameras[i];
      if(current.lensDirection == CameraLensDirection.back){
        camera = current;
        break;
      }
    }

    if(cameras != null){
      _cameraSelected(camera!);
    }
  }

  void _cameraSelected(CameraDescription camera) async {
    _cameraController = CameraController(
      camera, 
      ResolutionPreset.max, 
      enableAudio: false
      );

      await _cameraController?.initialize();

      if(!mounted){
        return;
      }
      setState(() {});
  }

  Future<void> _scanImage() async {
    if(_cameraController == null) return;

    final navigator = Navigator.of(context);

    try{
      final pictureImage = await _cameraController!.takePicture();
      final file = File(pictureImage.path);
      final inputImage = InputImage.fromFile(file);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      await Navigator.push(context, MaterialPageRoute(builder: (context) => ResultScannerPage(text: recognizedText.text)));
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("An error occured when scanning")));
    }
  }


  @override
    void didChangeApplifecycleState(AppLifecycleState state){
      // TODO: Camera flow
      if(_cameraController == null || !_cameraController!.value.isInitialized){
        return;
      }

      if(state == AppLifecycleState.inactive){
        _stopCamera();
      }else if(state == AppLifecycleState.resumed && 
      _cameraController != null && 
      _cameraController!.value.isInitialized){
        _startCamera();
      }
    }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future, 
      builder: (context, snapshot){
        return Stack(
          children: [
            if(_isPermissionGranted)
            FutureBuilder(
              future: availableCameras(), 
              builder: (context, snapshot){
                if(snapshot.hasData){
                  _initCameraController(snapshot.data!);
                  return Center(child: CameraPreview(_cameraController!),);
                }else{
                  return const LinearProgressIndicator();
                }
              }
              ),
                  Scaffold(
                      appBar: AppBar(),
                      backgroundColor: _isPermissionGranted ? Colors.transparent : null,
                      body: _isPermissionGranted 
                      ? Column(
                        children: [
                          Expanded(
                            child: Container(),
                          ),
                          ScanButton(press: () { _scanImage(); },)
                        ],
                      )
                      : Center(
                        child: Text("Camera Permission Denied")),
                      )
          ],
        );
      });
  }
}

class ScanButton extends StatelessWidget {
  const ScanButton({
    super.key, required this.press,
  });
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        height: 61,
        width: 383,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16)
        ),
        child: Center(child: Text("Scan Pasport!", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),)),
      ),
    );
  }
}