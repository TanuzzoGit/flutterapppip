
// class MyInputController extends StatefulWidget{
//   final String label;
//   final Function(String) onChanged;

//   const MyInputController({super.key, required this.label, required this.onChanged});

//   @override
//   State<MyInputController> createState() => _MyInputControllerState();
// }
// class _MyInputControllerState extends State<MyInputController> {
//   final TextEditingController _controller = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: _controller,
//       decoration: InputDecoration(labelText: widget.label),
//       onChanged: (value) {
//         widget.onChanged(value);
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }
