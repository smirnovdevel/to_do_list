// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

// import '../localization/app_localization.dart';

// ///
// /// Строка выбора времени задачи
// ///
// mixin RowDeadLine on StatefulWidget {
//   Widget RowDeadLineWidget(BuildContext context) {
//     final locale = AppLocalization.of(context).locale.languageCode;
//     return Padding(
//       padding: const EdgeInsets.only(top: 16.0, bottom: 34.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           GestureDetector(
//             onTap: () async {
//               if (_deadline != null) {
//                 // _deadline = await selectDate(context, _deadline);
//               }
//             },
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   AppLocalization.of(context).get('deadline'),
//                   style: Theme.of(context).textTheme.bodyMedium,
//                 ),
//                 if (_deadline == null)
//                   Container()
//                 else
//                   Text(
//                     DateFormat('dd MMMM yyyy', locale)
//                         .format(_deadline ?? DateTime.now()),
//                     style: Theme.of(context)
//                         .textTheme
//                         .bodyMedium!
//                         .copyWith(color: Theme.of(context).iconTheme.color),
//                   ),
//               ],
//             ),
//           ),
//           Switch(
//               value: _deadline != null,
//               onChanged: (bool value) {
//                 if (value) {
//                   _deadline = DateTime.fromMillisecondsSinceEpoch(
//                       DateTime.now().millisecondsSinceEpoch);
//                 } else {
//                   _deadline = null;
//                 }
//                 setState(() {});
//               }),
//         ],
//       ),
//     );
//   }
// }
