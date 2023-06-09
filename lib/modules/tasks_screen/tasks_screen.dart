import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/component/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class TasksScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
          return
            BlocConsumer<AppCubit,AppStates>(
              listener: (context,state){},
              builder: (context,state){
                return
                  ListView.separated(
                    itemBuilder: (context,index)=> buildTaskItem(AppCubit.get(context).newtasks[index],context),
                    separatorBuilder: (context,index)=> Container(height: 1,),
                    itemCount: AppCubit.get(context).newtasks.length,
                  );
              },
            );
      }
}