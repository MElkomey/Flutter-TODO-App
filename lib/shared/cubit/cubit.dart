
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_screen/archived_screen.dart';
import 'package:todo_app/modules/done_screen/done_screen.dart';
import 'package:todo_app/modules/tasks_screen/tasks_screen.dart';
import 'package:todo_app/shared/cubit/states.dart';
class AppCubit extends Cubit<AppStates>{

  AppCubit(): super(AppInitialState());

  static  AppCubit get(context)=>BlocProvider.of(context);


  var currentIndex = 0;
  List<Widget> screens = [
    TasksScreen(),
    DoneScreen(),
    ArchivedScreen(),
  ];
  List<String> titles = [
    'Tasks',
    'Done',
    'Archived',
  ];
  Database? database;
  List<Map>newtasks=[];
  List<Map>doneTasks=[];
  List<Map>archivedtasks=[];
  IconData fapicon = Icons.edit;
  bool isBottomSheetShown = false;

void bottomChange(index){
  currentIndex = index;
  emit(AppChangeBottomNavBarState());
}

void isBottomSheetChange({
  required bool isShow,
  required IconData icon,
}
){
  isBottomSheetShown=isShow;
  fapicon=icon;
  emit(AppChangeBottomSheetState());
}



  void createDatabase()  {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('database Created');
        database.execute(
            'CREATE TABLE tasks(id INTEGER PRIMARY KEY,title TEXT,date TEXT, time TEXT,status TEXT)');
      },
      onOpen: (database) {
        print('database opened');
        getDataFromDatabase(database);
      },
    ).then((value) {
      emit(AppCreateDatabaseState());
      database=value;
      print('TABLE opened');
    }).catchError((error) {
      print('database error when creating table ${error.toString()}');
    });
  }

  Future insertIntoDatabase(
      {
        required String title,
        required String time,
        required String date,
      }) async {

    await database!.transaction((txn) {
      return txn
          .rawInsert(
          'INSERT INTO tasks(title,date,time,status)VALUES("$title","$date","$time","new")')
          .then((value) {
        print('raw inserted successfully');
        emit(AppInsertIntoDBState());
        getDataFromDatabase(database);
      }).catchError((error) {
        print('ERROR when insert');
      });
    });
  }

   void getDataFromDatabase(database) {
  newtasks=[];
  doneTasks=[];
  archivedtasks=[];
  emit(AppGetDataBaseLodigState());
  //return
      database.rawQuery(
        'SELECT * FROM tasks'
    ).then((value) {
      newtasks=value;
      print(newtasks);
      value.forEach((element) {
        if (element['status']=='new')
      {newtasks.add(element);}else if(element['status']=='done'){doneTasks.add(element);}else{archivedtasks.add(element);}
      });
      emit(AppGetDataFormDBState());
    }
    );
  }

   updateData({
  required String status,
  required int id,
}) async{
    database!.rawUpdate(
       'UPDATE tasks SET status = ? WHERE id = ?',
       [status, id]).then((value) {
         getDataFromDatabase(database);
         emit(AppUpdateDataState());
    });
  }


}