import 'package:flutter/material.dart';
import 'package:to_do_app_1/main.dart';
import 'package:to_do_app_1/models/task_model.dart';
import 'package:to_do_app_1/data/local_storage.dart';

import 'task_list_item.dart';

class CustomSearchDelegate extends SearchDelegate{
  final List<Task> allTask;

  CustomSearchDelegate({required this.allTask});



  @override
  List<Widget>? buildActions(BuildContext context) {
     
     return [
      IconButton(
        onPressed: (){
          query.isEmpty ? null: query = "";
        }, 
      icon: const Icon(Icons.clear))
     ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: (){
         close(context, null);
      }, 
      icon: Icon(Icons.arrow_back_ios,size: 24,));
  }

  @override
  Widget buildResults(BuildContext context) {
    var filteredList = allTask.where(
      (task) => task.name.toLowerCase().contains(query.toLowerCase())).toList();
    return filteredList.isNotEmpty ? ListView.builder(
        itemBuilder:(context, index) {
          var oankieleman=filteredList[index];
          return Dismissible(
            background: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delete,color: Colors.red,),
                SizedBox(width: 8,),
                Text("Görev Siliniyor..")
              ],

            ),
            key: Key(oankieleman.id),
            onDismissed:(direction)async {
              filteredList.removeAt(index);
              await locator<LocalStorage>().deleteTask(task: oankieleman);

            },
            child: TaskItem(task: oankieleman)
          );
        },
        itemCount: filteredList.length,
        ): Center(child: Text("Aradığınız Bulunamadı"),);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

}