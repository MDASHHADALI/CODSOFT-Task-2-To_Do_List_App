import 'package:hive_flutter/hive_flutter.dart';
class HiveDatabase
{
  final _myBox=Hive.box("myBox");
  void addData(List<String> data)
  {
   _myBox.put("Task", data);
  }
  void completedList(List<bool> data)
  {
    _myBox.put("Complete", data);
  }
  List<String>readData()
  {
    List<String> k=[];
    List data= _myBox.get("Task")??[];
    for(var i=0;i<data.length;i++)
      {
         k.add(data[i]);
      }
    return k;
  }
  List<bool>readData2()
  {
    List data= _myBox.get("Complete")??<bool>[];
    List<bool> k=[];
    for(var i=0;i<data.length;i++)
    {
      k.add(data[i]);
    }
    return k;
  }
}