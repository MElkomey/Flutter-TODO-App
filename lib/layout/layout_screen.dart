import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_screen/archived_screen.dart';
import 'package:todo_app/modules/done_screen/done_screen.dart';
import 'package:todo_app/modules/tasks_screen/tasks_screen.dart';
import 'package:todo_app/shared/component/components/components.dart';
import 'package:todo_app/shared/component/components/constants.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class LayoutScreen extends StatelessWidget {
  var TitleControlre = TextEditingController();
  var TimeController = TextEditingController();
  var DateController = TextEditingController();


  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
   // AppCubit cubit= AppCubit.get(context);

  return
    BlocProvider(
      create: (BuildContext context)=>AppCubit()..createDatabase(),
    child:
     BlocConsumer<AppCubit,AppStates>(
       listener:(BuildContext context,AppStates state) {
         if(state is AppInsertIntoDBState){
           Navigator.pop(context);
         }
       } ,
      builder:(BuildContext context,AppStates state){
         return
           Scaffold(
             key: scaffoldKey,
             appBar: AppBar(
               title: Text(
                 AppCubit.get(context).titles[  AppCubit.get(context).currentIndex],
               ),
             ),
             bottomNavigationBar: BottomNavigationBar(
               currentIndex:  AppCubit.get(context).currentIndex,
               elevation: 150.0,
               onTap: (index) {
                 AppCubit.get(context).bottomChange(index);
               },
               items: [
                 BottomNavigationBarItem(
                   icon: Icon(
                     Icons.menu,
                   ),
                   label: 'Tasks',
                 ),
                 BottomNavigationBarItem(
                   icon: Icon(
                     Icons.done_outline,
                   ),
                   label: 'Done',
                 ),
                 BottomNavigationBarItem(
                   icon: Icon(
                     Icons.archive_outlined,
                   ),
                   label: 'Archived',
                 ),
               ],
             ),
             body: State is!AppGetDataBaseLodigState? AppCubit.get(context).screens[AppCubit.get(context).currentIndex]:Center(child: CircularProgressIndicator()),
             //AppCubit.get(context).screens[AppCubit.get(context).currentIndex],
             // ConditionalBuilder(
             //   condition: tasks.length >0,
             //   builder:(context)=> screens[currentIndex],
             //   fallback:(context)=> Center(child: CircularProgressIndicator()),
             //     ),
             floatingActionButton: FloatingActionButton(
               onPressed: () {
                 print('button clicked');
                 if (AppCubit.get(context).isBottomSheetShown) {
                   if(formKey.currentState!.validate()){
                     AppCubit.get(context).insertIntoDatabase(
                         title: TitleControlre.text,
                         time: TimeController.text,
                         date: DateController.text);
                    // Navigator.pop(context);
                     AppCubit.get(context).isBottomSheetChange(isShow:false,icon:Icons.edit);

                     // insertIntoDatabase(
                     //   title: TitleControlre.text,
                     //   date: DateController.text,
                     //   time: TimeController.text,
                     // ).then((value) {
                     //   print('insertedddd............');
                     //
                     //   getDataFromDatabase(database).then((value) {
                     //     tasks=value;
                     //     print(tasks);
                     //   });
                     //   // setState(() {
                     //   //   isBottomSheetShown = false;
                     //   //   fapicon = Icons.edit;
                     //   // });
                     // });
                   }
                 } else {
                   scaffoldKey.currentState!.showBottomSheet(
                         (context) => Container(
                       padding: EdgeInsets.all(10.0),
                       color: Colors.grey[150],
                       child: Form(
                         key: formKey,
                         child: Column(
                           mainAxisSize: MainAxisSize.min,
                           children: [
                             defaultTextForm(
                               contrl: TitleControlre,
                               typ: TextInputType.text,
                               validte: (value) {
                                 if(value!.isEmpty){
                                   return 'this form must not be empty';
                                 }
                                 return null;
                               },
                               labell: 'Title',
                               prefix: Icons.title,
                             ),
                             SizedBox(
                               height: 10.0,
                             ),
                             defaultTextForm(
                               contrl: TimeController,
                               ontap: () {
                                 showTimePicker(
                                   context: context,
                                   initialTime: TimeOfDay.now(),
                                 ).then((value) {
                                   TimeController.text =
                                       value!.format(context).toString();
                                 });
                               },
                               typ: TextInputType.datetime,
                               validte: (value) {
                                 if(value!.isEmpty){
                                   return 'this form must not be empty';
                                 }
                                 return null;
                               },
                               labell: 'Time',
                               prefix: Icons.watch_later_outlined,
                             ),
                             SizedBox(
                               height: 10.0,
                             ),
                             defaultTextForm(
                               contrl: DateController,
                               ontap: () {
                                 showDatePicker(
                                     context: context,
                                     initialDate: DateTime.now(),
                                     firstDate: DateTime.now(),
                                     lastDate: DateTime.parse('2022-03-28')
                                 ).then((value) {
                                   DateController.text=DateFormat.yMMMd().format(value!);
                                 });
                               },
                               typ: TextInputType.datetime,
                               validte: (value) {
                                 if(value!.isEmpty){
                                   return 'this form must not be empty';
                                 }
                                 return null;
                               },
                               labell: 'Date',
                               prefix: Icons.watch_later_rounded,
                             ),
                           ],
                         ),
                       ),
                     ),
                   ).closed.then((value) {
                     AppCubit.get(context).isBottomSheetChange(isShow:false,icon:Icons.edit);
                   });
                   AppCubit.get(context).isBottomSheetChange(isShow:true,icon:Icons.add);
                 }

                 //insertIntoDatabase();

                 // var name=  getName().then((value){print(value);}).catchError((erroe){print('erreorrrororor');});
                 // print(name);
               },
               child: Icon(AppCubit.get(context).fapicon),
             ),
           );

      }
       ),
    );

  }





}


