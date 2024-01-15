import 'package:flutter/cupertino.dart';
import 'hive_database..dart';
final db=HiveDatabase();
class ListProvider extends ChangeNotifier{
   List<String> list=db.readData();
   List<bool> completedtask=db.readData2();


  void add(String description)
  {
    list.add(description);
    completedtask.add(false);
    db.addData(list);
    db.completedList(completedtask);
    notifyListeners();
  }
  void edit(String description,int index)
  {
    list[index]=description;
    db.addData(list);
    notifyListeners();
  }
  void delete(int index)
  {
    list.removeAt(index);
    completedtask.removeAt(index);
    db.addData(list);
    db.completedList(completedtask);
    notifyListeners();
  }
  void notify()
  {
    notifyListeners();
  }
  void changetask(int index,bool value)
  {
    completedtask[index]=value;
    db.completedList(completedtask);
    notifyListeners();
  }
}