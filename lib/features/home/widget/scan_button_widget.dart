import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ScanCard extends StatefulWidget {
  const ScanCard({
    super.key, required this.press,
  });
  final VoidCallback press;

  @override
  State<ScanCard> createState() => _ScanCardState();
}

class _ScanCardState extends State<ScanCard> {
   double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = 0.95);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0);
    widget.press(); // Trigger action
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.press,
      child: AnimatedScale(
        duration: Duration(milliseconds: 150),
        scale: _scale,
        child: Container(
          height: 120,
          width: 380,
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color.fromRGBO(214, 214, 214, 1),
              width: 2
            )
          ) ,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 25,
                child: SvgPicture.asset('assets/icons/material-symbols_scan-outline-rounded.svg', )),
              SizedBox(height: 10,),
              Text("Scan", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),)
            ]
          ),
        ),
      ),
    );
  }
}