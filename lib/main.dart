import 'package:flutter/material.dart';
//import 'package:todo_app/layout/counter_with_cubit/counter_with_cubit.dart';
import 'package:todo_app/layout/layout_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/bloc_observer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
   return(
   MaterialApp(
     //debugShowCheckedModeBanner: false,
     home: LayoutScreen(),
   )
   );
  }

}