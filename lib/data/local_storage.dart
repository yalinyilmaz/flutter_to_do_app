

import 'package:hive/hive.dart';
import 'package:to_do_app_1/models/task_model.dart';

abstract class LocalStorage{
  Future<void> addTask({required Task task});
  Future<Task?> getTask({required String id});
  Future<List<Task>> getAllTask();
  Future<bool> deleteTask({required Task task});
  Future<Task> updateTask({required Task task}); 
}

class HiveLocalStorage extends LocalStorage{
   late Box<Task> taskbox;

  HiveLocalStorage(){
    taskbox = Hive.box<Task>("tasks");
  }
  @override
  Future<void> addTask({required Task task}) async{
   await taskbox.put(task.id, task);
  }

  @override
  Future<bool> deleteTask({required Task task})async {
    await taskbox.delete(task.id);
    return true;
  }

  @override
  Future<List<Task>> getAllTask()async{
     List<Task> alltask = <Task>[];
     alltask= taskbox.values.toList();

     if(alltask.isNotEmpty){
      alltask.sort((Task a,Task b) => b.createdAt.compareTo(a.createdAt),);
      return alltask;
      }
      else {
        return [];
      }
  }

  @override
  Future<Task?> getTask({required String id})async {
    if(taskbox.containsKey(id)){
      return taskbox.get(id);
    }
    else{
      return null;
    }
  }

  @override
  Future<Task> updateTask({required Task task})async {
    await task.save();
    return task;
  }


}