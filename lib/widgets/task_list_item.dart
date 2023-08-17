import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app_1/data/local_storage.dart';
import 'package:to_do_app_1/main.dart';

import '../models/task_model.dart';

class TaskItem extends StatefulWidget {
  final Task task;
  TaskItem({super.key,required this.task});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  TextEditingController taskname = TextEditingController();
  late LocalStorage localStorage;


  @override
  void initState() { 
    super.initState();
    localStorage =locator<LocalStorage>();
    
  }
  @override
  Widget build(BuildContext context) {
    taskname.text = widget.task.name;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8,vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.2),
            blurRadius: 10,
            offset:const Offset(0, 4)
          )
        ]
      ),
      child: ListTile(
        leading: GestureDetector(
          onTap: () {
            widget.task.isCompleted =!widget.task.isCompleted;
            localStorage.updateTask(task: widget.task);
            setState(() {
              
            });
          },
          child: Container(
            child: const Icon(Icons.check,color: Colors.white,),
            decoration: BoxDecoration(
              color:widget.task.isCompleted ? Colors.green : Colors.white,
              border: Border.all(color: Colors.grey),
              shape: BoxShape.circle,),
              )),
        title: widget.task.isCompleted ? Text(widget.task.name,style: TextStyle(decoration: TextDecoration.lineThrough,color:Colors.grey ),): 
        TextField(
          controller: taskname,
          minLines: 1,
          maxLines: null,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(border:InputBorder.none ),
          onSubmitted: (value) {
            if (value.length>3){
            widget.task.name = value;
            localStorage.updateTask(task:widget.task);
            setState(() {
              
            });
            }
          },),
          trailing: Text(
            DateFormat("hh:mm a").format(widget.task.createdAt),
            style: TextStyle(fontSize: 14,color: Colors.grey),
          ),
      ),

    );
  }
}