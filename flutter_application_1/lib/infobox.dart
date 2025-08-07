import 'package:flutter/material.dart';
class infobox extends StatefulWidget{

   final String? label;
   final String? value;
   final Icon? icon;
   final Color? avatarColor;
   const infobox({super.key,  this.label,  this.value, this.icon, this.avatarColor});

  @override
  State<infobox> createState() => _infoboxstate();
}

class _infoboxstate extends State<infobox>{
  @override
  Widget build(BuildContext context){
    return Row(
                                children: [
                                  CircleAvatar(
                                  backgroundColor: widget.avatarColor,
                                  child:
                                  widget.icon,),
                                  SizedBox(width:10),
                                  Expanded(child:
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:[
                                    
                                  Text(
                                    "${widget.label}:",
                                    style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  Text(
                                    widget.value ?? "NA",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ])),
                              ]);
  }
}