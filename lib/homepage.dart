
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list_app/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int ind = -2;
  final descController=TextEditingController();
  bool validateDesc=false;

   void _dialog(ListProvider providerModel) {
   showDialog(context: context, builder: (context){return StatefulBuilder(
     builder: (context,setState) {
       return SizedBox(
         child: AlertDialog(
           backgroundColor: Colors.white,
           title:  Padding(
             padding: const EdgeInsets.only(left: 1.6),
             child: Text((ind==-2)?"Add Task":"Edit Task",style: TextStyle(fontWeight: FontWeight.bold),),
           ),
           actions: [
             TextButton(onPressed: (){
               validateDesc=descController.text.isEmpty;
               if(validateDesc)
                 {
                  setState((){});
                 }
               else
                 {
                   if(ind==-2)
                   providerModel.add(descController.text);
                   else
                     providerModel.edit(descController.text, ind);

                   descController.clear();
                   Navigator.pop(context);
                 }
             }, child:  Text(
               (ind==-2)?
               "ADD":"SAVE",
               style: TextStyle(
                 fontWeight: FontWeight.bold,
                 fontSize: 16,
               ),
             ),
             ),
             TextButton(onPressed: (){
               if(ind!=-2) {
                 providerModel.notify();
               }
               descController.clear();
               Navigator.pop(context);
             }, child: const Text(
               "CANCEL",
               style: TextStyle(
                 fontWeight: FontWeight.bold,
                 fontSize: 16,
               ),
             ),
             )
           ],
       content: SizedBox(
       height: 100,
       width: 400,
       child: SingleChildScrollView(
       child: Column(
       children: [
       TextField(
       controller: descController,
       decoration:  InputDecoration(
       hintText: "Enter the Description",
       labelText: "Description",
       errorText: (validateDesc)?"Enter the description":null,
       hintStyle: TextStyle(
       color: Colors.blueGrey,
       ),
       border: OutlineInputBorder(),
       ),
         onChanged: (value)=>{
         if(validateDesc==true)
         setState((){validateDesc=false;})},
       ),]))),
         ),
       );
     }
   );} );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ListProvider>(
      builder: (context,providermodel,child) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text(widget.title),
              centerTitle: true,
              leading: Icon(Icons.task_rounded),

            ),
            backgroundColor: Colors.grey.shade300,
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Ink(
                  decoration:BoxDecoration(
                    border: Border.all(),
                    color: Colors.white
                  ),
                  child:
                  Column(
                    children: [
                      Text("All Tasks",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                      Text((providermodel.list.isEmpty)?"\n\n\nNo Task\n\n\n":"",textAlign: TextAlign.center,),
                      Ink(
                        height: 80.0*providermodel.list.length,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: providermodel.list.length,
                          itemBuilder:(context,index ){
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                splashColor: Colors.amber,
                                highlightColor: Colors.green,
                                hoverColor: Colors.pinkAccent,
                                onTap: (){
                                },
                
                                child: Dismissible(
                                  child:
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      boxShadow: [BoxShadow(blurRadius:10.0,color: Colors.white70)],
                                      border: Border.all(color: Colors.black),
                                    ),
                                    child: ListTile(leading:Icon(Icons.list),
                                      title: Text(providermodel.list[index],style: TextStyle(color: Colors.deepPurple,fontSize: 15),softWrap: true,textAlign: TextAlign.center,
                                  ),
                                    trailing: Checkbox(value: providermodel.completedtask[index], onChanged: (value){
                                      providermodel.changetask(index, value!);
                                    }),
                                    )),
                                  background: Container(color: Colors.redAccent,child: Row(
                                    children: [
                                      SizedBox(width: 10,),
                                      Icon(Icons.delete),
                                    ],
                                  ),),
                                  secondaryBackground: Container(color: Colors.greenAccent,child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(Icons.edit),
                                      SizedBox(width: 10,),
                                    ],
                                  ),),
                                  key: UniqueKey(),
                                  direction: DismissDirection.horizontal,
                                  confirmDismiss: (DismissDirection direction) async {
                                    if(direction==DismissDirection.startToEnd)
                                    return await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Confirm"),
                                          content: const Text("Are you sure you wish to delete this item?"),
                                          actions: <Widget>[
                                            FilledButton(
                                                onPressed: () => Navigator.of(context).pop(true),
                                                child: const Text("DELETE")
                                            ),
                                            FilledButton(
                                              onPressed: () => Navigator.of(context).pop(false),
                                              child: const Text("CANCEL"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    else
                                     return await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text("Confirm"),
                                            content: const Text("Do you wish to edit this item?"),
                                            actions: <Widget>[
                                              FilledButton(
                                                  onPressed: () => Navigator.of(context).pop(true),
                                                  child: const Text("EDIT"),
                                              ),
                                              FilledButton(
                                                onPressed: () => Navigator.of(context).pop(false),
                                                child: const Text("CANCEL"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                
                                  },
                                  onDismissed: (DismissDirection direction) {
                                       if(direction==DismissDirection.startToEnd)
                                         {
                                           providermodel.delete(index);
                                         }
                                       else
                                         {
                                           descController.text=providermodel.list[index];
                                           ind=index;
                                           _dialog(providermodel);
                                         }
                                    }
                                    ),
                                    ),
                                    );
                                  },
                        ),
                        ),
                      ],
                  ),
                ),
              ),
            ),
          
            floatingActionButton: FloatingActionButton(
              onPressed:()=>{
                validateDesc=false,
                ind=-2,
                _dialog(providermodel)},
              tooltip: 'Add Task',
              child: const Icon(Icons.add),
            ),
          ),
        );
      }
    );
  }
}
