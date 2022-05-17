import 'package:flutter/material.dart';
import 'package:haffle/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messagetextcontroller = TextEditingController();
  final _auth  = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  late User loggedInUser;
  late String messagetext;
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('messages').snapshots();

  @override
  void initState() {

    super.initState();

    getCurrentuser();
  }

  void getCurrentuser()async{
    try {
      final user = await _auth.currentUser!;
      {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch(e){

      print(e);
    }
  }
  // void messagestream()async{
  //   await for (var snapshot in _firestore.collection('messages').snapshots()) {
  //     for (var message in snapshot.docs){
  //       print(message.data());
  //
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('️ HAFFLE '),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('messages').snapshots(),
                builder: (context, snapshot){
                  if (snapshot.hasData) {
                    final messages = snapshot.data!.docs.reversed;
                    late List<messagebubble> messagewidgets = [];
                    for (var message in messages ){
                      final messagetext = message.get('text');
                      final messagesender = message.get('sender');
                      final currentuser = loggedInUser.email;
                      final messagedatetime = message.get('date and time');


                      final messagewidget = messagebubble(
                        sender: messagesender,
                        text: messagetext,
                        isme: currentuser == messagesender,
                        datetime : messagedatetime,

                      );
                      messagewidgets.add(messagewidget);
                      messagewidgets.sort( (a,b) => DateTime.parse(b.datetime).compareTo(DateTime.parse(a.datetime)));


                    }
                    return Expanded(
                      child: ListView(
                        reverse: true,
                        padding: EdgeInsets.symmetric(horizontal: 12,vertical: 21),
                        children: messagewidgets,
                      ),
                    );
                  }throw'';
                }
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messagetextcontroller,
                      onChanged: (value) {
                        messagetext= value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      messagetextcontroller.clear();
                      _firestore.collection('messages').add({
                        'text': messagetext,
                        'sender': loggedInUser.email,
                        'date and time' : DateTime.now().toString(),
                      });
                    },
                    child: Text(
                      'Send ',
                      style: kSendButtonTextStyle,

                    ),

                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class messagebubble extends StatelessWidget {
  messagebubble({required this.sender,required this.text,required this.isme,required this.datetime});

  final String sender;
  final String text;
  final String datetime;
  final bool isme;

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding:  EdgeInsets.all(12.0),

      child: Column(
        crossAxisAlignment:isme ?  CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(sender,style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54
          ),),
          Material(
              borderRadius:isme ?  BorderRadius.only(topLeft:  Radius.circular(30) ,bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)) : BorderRadius.only(topRight: Radius.circular(30),bottomRight: Radius.circular(30),bottomLeft: Radius.circular(30)),
              elevation: 9,
              color: isme ? Colors.lightBlueAccent : Colors.white,
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 21,vertical: 12),
                child: Text (text,
                  style: TextStyle(
                      color: isme ? Colors.white : Colors.black ,
                      fontSize: 15
                  ),
                ),
              )),
        ],
      ),
    );
  }
}