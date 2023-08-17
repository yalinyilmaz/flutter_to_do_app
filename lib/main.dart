
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app_1/data/local_storage.dart';
import 'pages/homepage.dart';
import 'package:to_do_app_1/models/task_model.dart';
import 'package:get_it/get_it.dart';


final locator = GetIt.instance;

void setup(){
  locator.registerSingleton<LocalStorage>(HiveLocalStorage());
}

Future<void> setupHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TaskAdapter());
    var taskBox = await Hive.openBox<Task>("tasks");
    for (var element in taskBox.values) {
      if(element.createdAt.day != DateTime.now().day){
        taskBox.delete(element.id);

      }
    }

}
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    await setupHive();
    setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme:const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black)
        )
      ),  
      home: const Homepage(),
    );
  }
}
