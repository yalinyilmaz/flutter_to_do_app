import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:to_do_app_1/models/task_model.dart';
import 'package:to_do_app_1/widgets/custom_search_delegate.dart';
import 'package:to_do_app_1/widgets/task_list_item.dart';
import 'package:to_do_app_1/data/local_storage.dart';
import 'package:to_do_app_1/main.dart';


class Homepage extends StatefulWidget {
  const Homepage({
    super.key,
  });

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late List<Task> allTask;
  late LocalStorage localStorage;

@override
  void initState() {
    super.initState();
    localStorage = locator<LocalStorage>();
    allTask=[];
    getAllTaskFromDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("What is your plan today?",style: TextStyle(color: Colors.black),),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: (){
              _showSearchPage();
            }, 
            icon:const Icon(Icons.search)),
            IconButton(
            onPressed: (){
              _showAddTaskbottomSheet(context);
            }, 
            icon:const Icon(Icons.add))
        ],
      ),
      body: allTask.isNotEmpty ? ListView.builder(
        itemBuilder:(context, index) {
          var oankieleman=allTask[index];
          return Dismissible(
            background: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delete,color: Colors.red,),
                SizedBox(width: 8,),
                Text("Task Deleting..")
              ],

            ),
            key: Key(oankieleman.id),
            onDismissed:(direction) {
              allTask.removeAt(index);
              localStorage.deleteTask(task: oankieleman);
              setState(() {
                
              });
            },
            child: TaskItem(task: oankieleman)
          );
        },
        itemCount: allTask.length,
        ): Center(child: Text("Add Task!"),)
    );
  }


void _showAddTaskbottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context, 
    builder:(context) {
    return Padding(
      padding: EdgeInsets.only(bottom:MediaQuery.of(context).viewInsets.bottom),
      child: ListTile(
        title: TextField(
          autofocus: false,
          style: TextStyle(fontSize: 20),
          decoration: InputDecoration(
            hintText: "type a task!",
            border: InputBorder.none,
            ),
            onSubmitted: (value) {              
              Navigator.of(context).pop();
              if(value.length>3){
              DatePicker.showTimePicker(
                context,
                showSecondsColumn: false,
                onConfirm:(time)async {
                  var yenieklencektask=Task.create(name: value, createdAt: time);
                  allTask.insert(0, yenieklencektask); 
                  await localStorage.addTask(task: yenieklencektask);
                  setState(() {
                    
                  });
                },
                );
              }                        
            },
        ),
      ),
    ); 
    
  },);

}

  Future<void> getAllTaskFromDB() async {

    allTask = await localStorage.getAllTask();
    setState(() {
      
    });
  }
  
  void _showSearchPage() async{
    await showSearch(context: context, delegate: CustomSearchDelegate(allTask: allTask));
    getAllTaskFromDB();
  }

}