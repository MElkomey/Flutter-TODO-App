// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:todo_app/modules/archived_screen/archived_screen.dart';
// import 'package:todo_app/modules/done_screen/done_screen.dart';
// import 'package:todo_app/modules/tasks_screen/tasks_screen.dart';
// import 'package:todo_app/shared/component/components/components.dart';
//
// class LayoutScreen1 extends StatefulWidget {
//   @override
//   State<LayoutScreen> createState() => _LayoutScreenState();
// }
//
// class _LayoutScreenState extends State<LayoutScreen> {
//   var TitleControlre = TextEditingController();
//   var TimeController = TextEditingController();
//   var DateController = TextEditingController();
//   IconData fapicon = Icons.edit;
//   bool isBottomSheetShown = false;
//   Database? database;
//   var currentIndex = 0;
//   List<Widget> screens = [
//     TasksScreen(),
//     DoneScreen(),
//     ArchivedScreen(),
//   ];
//   List<String> titles = [
//     'Tasks',
//     'Done',
//     'Archived',
//   ];
//   var scaffoldKey = GlobalKey<ScaffoldState>();
//   var formKey = GlobalKey<FormState>();
//   @override
//   void initState() {
//     super.initState();
//     createDatabase();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return (Scaffold(
//       key: scaffoldKey,
//       appBar: AppBar(
//         title: Text(
//           titles[currentIndex],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: currentIndex,
//         elevation: 150.0,
//         onTap: (index) {
//           setState(() {
//             currentIndex = index;
//           });
//         },
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.menu,
//             ),
//             label: 'Tasks',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.done_outline,
//             ),
//             label: 'Done',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(
//               Icons.archive_outlined,
//             ),
//             label: 'Archived',
//           ),
//         ],
//       ),
//       body: screens[currentIndex],
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           print('button clicked');
//           if (isBottomSheetShown) {
//             if(formKey.currentState!.validate()){
//               insertIntoDatabase(
//                 title: TitleControlre.text,
//                 date: DateController.text,
//                 time: TimeController.text,
//               ).then((value) {
//                 print('insertedddd............');
//                 Navigator.pop(context);
//                 setState(() {
//                   isBottomSheetShown = false;
//                   fapicon = Icons.edit;
//                 });
//               });
//             }
//           } else {
//             scaffoldKey.currentState!.showBottomSheet(
//                   (context) => Container(
//                 padding: EdgeInsets.all(10.0),
//                 color: Colors.grey[150],
//                 child: Form(
//                   key: formKey,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       defaultTextForm(
//                         contrl: TitleControlre,
//                         typ: TextInputType.text,
//                         validte: (value) {
//                           if(value!.isEmpty){
//                             return 'this form must not be empty';
//                           }
//                           return null;
//                         },
//                         labell: 'Title',
//                         prefix: Icons.title,
//                       ),
//                       SizedBox(
//                         height: 10.0,
//                       ),
//                       defaultTextForm(
//                         contrl: TimeController,
//                         ontap: () {
//                           showTimePicker(
//                             context: context,
//                             initialTime: TimeOfDay.now(),
//                           ).then((value) {
//                             TimeController.text =
//                                 value!.format(context).toString();
//                           });
//                         },
//                         typ: TextInputType.datetime,
//                         validte: (value) {
//                           if(value!.isEmpty){
//                             return 'this form must not be empty';
//                           }
//                           return null;
//                         },
//                         labell: 'Time',
//                         prefix: Icons.watch_later_outlined,
//                       ),
//                       SizedBox(
//                         height: 10.0,
//                       ),
//                       defaultTextForm(
//                         contrl: DateController,
//                         ontap: () {
//                           showDatePicker(
//                               context: context,
//                               initialDate: DateTime.now(),
//                               firstDate: DateTime.now(),
//                               lastDate: DateTime.parse('2022-03-28')
//                           ).then((value) {
//                             DateController.text=DateFormat.yMMMd().format(value!);
//                           });
//                         },
//                         typ: TextInputType.datetime,
//                         validte: (value) {
//                           if(value!.isEmpty){
//                             return 'this form must not be empty';
//                           }
//                           return null;
//                         },
//                         labell: 'Date',
//                         prefix: Icons.watch_later_rounded,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//             setState(() {
//               isBottomSheetShown = true;
//               fapicon = Icons.add;
//             });
//           }
//
//
//           //insertIntoDatabase();
//
//           // var name=  getName().then((value){print(value);}).catchError((erroe){print('erreorrrororor');});
//           // print(name);
//         },
//         child: Icon(fapicon),
//       ),
//     ));
//   }
//
//   // Future<String> getName() async{
//   // return('mohamed elkomey');
//   //}
//
//   void createDatabase()  {
//     openDatabase(
//       'todo.db',
//       version: 1,
//       onCreate: (database, version) {
//         print('database Created');
//         database.execute(
//             'CREATE TABLE tasks(id INTEGER PRIMARY KEY,title TEXT,date TEXT, time TEXT,status TEXT)');
//       },
//       onOpen: (database) {
//         print('database opened');
//       },
//     ).then((value) {
//       database=value;
//       print('TABLE opened');
//     }).catchError((error) {
//       print('database error when creating table ${error.toString()}');
//     });
//   }
//
//   Future insertIntoDatabase(
//       {
//         required String title,
//         required String time,
//         required String date,
//       }) async {
//
//     await database!.transaction((txn) {
//       return txn
//           .rawInsert(
//           'INSERT INTO tasks(title,date,time,status)VALUES("$title","$date","$time","new")')
//           .then((value) {
//         print('raw inserted successfully');
//       }).catchError((error) {
//         print('ERROR when insert');
//       });
//     });
//   }
// }
//
// // Future<String> getName() async {
// //   return ('mohamed elkomey');
// // }
//
// // // ///errorr handling///
// //
// // // ///1-try and catch////
// // // try{
// // //   var name=await getName();
// // //   print(name);
// // //   print('osama');
// // //   throw('i had an error');
// // // }
// // // catch(erroer){
// // //   print('error:  ${erroer.toString()}');
// // // }
// //
// // // ///2- .then///
// // //بتضمن التنفيذ بالترتيب عشان في حاجات بتسبق حاجات وافضل من الtry , catch
// // getName().then((value) {
// // print(value);
// // print('osama');
// // //throw('error');
// // }
// // ).catchError((error) {
// // print('Erorr: انا عملت ايرور');
// // });
//
// // void createDatabase() {
// //   var database =  openDatabase(
// //
// //     version: 1,
// //     onCreate: (database,version){
// //
// //       print('database created');
// //       database.execute('CREATE table tasks(id INTEGER PRIMARY KEY,title TEXT,date TEXT,time TEXT,status TEXT)');
// //       print('table created');
// //     },
// //     onOpen:(database){
// //       print('database opened');
// //     } ,
// //   ).then((value) {
// //     print('done');
// //   }).catchError((error) {
// //     print('Erorr: انا عملت ايرور');
// //   });
// //
// // }
