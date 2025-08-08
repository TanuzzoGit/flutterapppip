import 'package:flutter/material.dart';

class Roundedbutton extends StatefulWidget {
  final Color boxshadow;
  final Color bgcolor;
  final Icon ico;
  final Function fun;
  final BoxBorder? border;
  Roundedbutton({super.key,required this.boxshadow,required this.bgcolor,required this.ico,required this.fun,this.border});

  @override
  State<Roundedbutton> createState() => _roundedbuttonstate();
} 

class _roundedbuttonstate extends State<Roundedbutton>{

  @override
  Widget build(BuildContext context){
    return 
                                         Container(
                                           padding: EdgeInsets.all(0),
                                           decoration: BoxDecoration(
                                             borderRadius: BorderRadius.circular(
                                               50,
                                             ),
                                             border:widget.border,
                                             boxShadow: [
                                               BoxShadow(
                                                 color: widget.boxshadow,
                                                 blurRadius: 15,
                                                 spreadRadius: 0,
                                               ),
                                             ],
                                             color:widget.bgcolor),
                                           child: IconButton(
                                             onPressed: (){
                                              print("AAAAAAAAAAAAAAAAAAAA");
                                             widget.fun();},
                                             icon: widget.ico
                                           ),
                                         );
  }
}