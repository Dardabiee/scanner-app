import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CardButton extends StatefulWidget {
  const CardButton({
    super.key, required this.title, required this.icon, required this.color, required this.press,
  });
  final String title;
  final String icon;
  final Color color;
  final VoidCallback press;

  @override
  State<CardButton> createState() => _CardButtonState();
}

class _CardButtonState extends State<CardButton> {
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
                width: 180,
                decoration: BoxDecoration(
                  color:  widget.color,
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
                      child: SvgPicture.asset(widget.icon, )),
                    SizedBox(height: 10,),
                    Text(widget.title, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),)
                  ]
                ),
              ),
      ),
    );
  }
}