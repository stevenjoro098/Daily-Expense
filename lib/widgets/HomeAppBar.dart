// import 'package:flutter/material.dart';
//
// class CustomAppBar extends StatefulWidget with PreferredSizeWidget {
//   const CustomAppBar({super.key});
//
//   @override
//   State<CustomAppBar> createState() => _CustomAppBarState();
//
//   @override
//   // TODO: implement preferredSize
//   Size get preferredSize => throw UnimplementedError();
// }
//
// class _CustomAppBarState extends State<CustomAppBar> {
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       title: Image.asset('assets/images/statistics.png', width: 40),
//       centerTitle: true,
//       leading: Builder(
//         builder: (context) {
//           return IconButton(
//             icon: const Icon(Icons.menu),
//             onPressed: () {
//               Scaffold.of(context).openDrawer();
//             },
//           );
//         },
//       ),
//     );
//   }
//
//   @override
//   Size get preferredSize => Size.fromHeight(kToolbarHeight);
// }
