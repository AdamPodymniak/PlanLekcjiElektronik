// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:go_router/go_router.dart';

// import "/webscrapper/scrapper.dart";
// import '/utils/theming.dart';

// class CategoryItem extends StatefulWidget {
//   final String? favClass;
//   final AllLessons data;
//   const CategoryItem({this.favClass, required this.data, super.key});

//   @override
//   State<CategoryItem> createState() => _CategoryItemState();
// }

// class _CategoryItemState extends State<CategoryItem> {
//   @override
//   Widget build(BuildContext context) {
//     bool isFavourite = widget.data.title! == widget.favClass;

//
//     return Visibility(
//       visible: widget.data.type == searchingFor,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               context.go(
//                 '/',
//                 extra: widget.data,
//               );
//             },
//             child: Padding(
//               padding: const EdgeInsets.only(
//                 right: 55,
//                 top: 10,
//                 bottom: 10,
//               ),
//               child: Text(
//                 widget.data.title![widget.data.title!.length - 1] == "."
//                     ? widget.data.title!
//                         .replaceRange(widget.data.title!.length - 1, null, "")
//                     : widget.data.title!,
//                 style: const TextStyle(
//                   color: Theming.whiteTone,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//           IconButton(
//             onPressed: () async {
//               final prefs = await SharedPreferences.getInstance();
//               await prefs.setString("favourite", data.title!);

//               for (final cls in savedLessons!) {
//                 if (cls.title == widget.data.title) {
//                   favClassData = cls.lessonData;
//                   break;
//                 }
//               }
//               setState(() => widget.favClass = widget.data.title);
//             },
//             icon: Icon(
//               isFavourite ? Icons.star_rounded : Icons.star_border_rounded,
//               color: isFavourite
//                   ? Colors.yellow
//                   : Theming.whiteTone.withOpacity(0.3),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
