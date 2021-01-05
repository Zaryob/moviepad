import 'package:flutter/material.dart';
import 'note_provider.dart';

//import 'package:note/state_widget.dart';
enum Editing{
  Edit,
  Add,
}

class Note extends StatefulWidget {
  final Map<String, dynamic> note;
  final Editing mode;

  Note(this.mode,this.note);

  @override
  _NoteState createState() => _NoteState();
}

class _NoteState extends State<Note> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController textController = TextEditingController();


  @override
  void didChangeDependencies() {
    if(widget.mode == Editing.Edit){
      titleController.text= widget.note['title'];
      textController.text = widget.note['text'];
    }
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.mode == Editing.Add ? 'Add Note' : 'Edit Note',
        ),
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                  hintText: 'Title'
              ),
            ),
            TextField(
              maxLines: null,
              controller: textController,
              decoration: InputDecoration(
                  hintText: 'Text'
              ),
            ),
            Divider(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Button('Save',Colors.blue[900],(){
                  final title = titleController.text;
                  final text = textController.text;
                  if(widget?.mode == Editing.Add){
                    NoteProvider.insertNote({
                      'title' : title,
                      'text': text,
                    });

                  }else if(widget?.mode == Editing.Edit){
                    NoteProvider.uptadeNote({
                      'id': widget.note['id'],
                      'title': titleController.text,
                      'text': textController.text,
                    });
                  }
                  Navigator.pop(context);
                }),
                SizedBox(
                  width: 25,
                ),
                widget.mode == Editing.Edit ?
                Button('Delete',Colors.red[800],() async {
                  await NoteProvider.deleteNote(widget.note['id']);
                  Navigator.pop(context);
                })
                    : Container(),
                // Button('Go Back',Colors.grey,(){
                //   Navigator.pop(context);
                // }),

              ],
            )
          ],
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  String text;
  Color color;
  Function onPressed;
  Button(this.text,this.color,this.onPressed);
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed:onPressed,
      child: Text(
          '$text'
      ),
      color: color,
      textColor: Colors.white,
    );
  }
}

