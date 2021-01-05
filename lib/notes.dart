import 'note.dart';
import 'package:flutter/material.dart';
import 'note_provider.dart';

class noteList extends StatefulWidget {

  @override
  _noteListState createState() => _noteListState();
}

class _noteListState extends State<noteList> {
   Future<List<Map<String, dynamic>>> futureNotes = NoteProvider.getNoteList() ;
   void initState() {
     super.initState();
      futureNotes =  NoteProvider.getNoteList();
   }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Notes'),
        backgroundColor: Colors.blue[900],
      ),
      body: FutureBuilder(
        future: NoteProvider.getNoteList(),
        builder: (context, snapshot){
          if(snapshot.hasData/*snapshot.connectionState == ConnectionState.done*/){
            final notes = snapshot.data;
            return ListView.builder(
                itemBuilder: (context, index){
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder:(context) => Note(Editing.Edit, notes[index])));
                    },
                    child: Card(
                      color: Colors.blue[100],
                      child: Padding(
                        padding: const EdgeInsets.only(top:20, bottom:30,left:15,right:20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            nTitle(notes[index]['title']),
                            nText(notes[index]['text']),

                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: notes.length);
          }
          return Center(child: CircularProgressIndicator());

        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[900],
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder:(context) => Note(Editing.Add, null)));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
class nTitle extends StatelessWidget {
  final String title;
  nTitle(this.title);
  @override
  Widget build(BuildContext context) {
    return   Text(title.toUpperCase(),
      style: TextStyle(
        fontWeight:FontWeight.bold ,
        fontSize: 25,
      ),);
  }
}
class nText extends StatelessWidget {
  final String text;
  nText(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(text,
      style:TextStyle(
          color: Colors.grey.shade800
      ) ,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,);
  }
}
