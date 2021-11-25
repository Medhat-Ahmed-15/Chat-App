import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/chat/message.bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        //wrap el future el ana 3amlto dah 3ashan el 2wl 2ageeb el current user id ba3dein 2abtdy 2ageeb el messages

        future: FirebaseAuth.instance.currentUser(),
        builder: (ctx, futureSnapShot) {
          if (futureSnapShot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return StreamBuilder(
            stream: Firestore.instance
                .collection('chat')
                .orderBy('createdAt', descending: true)
                .snapshots(), //snapshots homa el reposible 2n yageele el updated messages mn el document el gowa collection automatically it returns a stream. Now, since it is a stream, that means it's going to emit new values whenever data changes, so that's that real time data aspect I mentioned earlier, it allows us to set up a listener through the Firebase Flattr SDK to our FIREBASE database. And whenever data changes in there, this listener will be notified automatically,

            builder: (ctx, snapshotData) {
              if (snapshotData.connectionState == ConnectionState.waiting) {
                //since that this data coming from (data.documents.length) isn't there from the start, intially when the request is sent behind the scenes at the data has received no data so that's why i had to check for the connection state
                return Center(child: CircularProgressIndicator());
              }
              final documents = snapshotData.data.documents;
              return ListView.builder(
                reverse:
                    true, //dah baybreverse tarteeb el data el gowa el list el homa el messages bdl mn fo2 la tht la2 mn tht la fo2
                //this itemBuilder that's in it ListView.builder will be rebuild whenever this stream gives us a new value and I don't need to add .listen because the stream builder do this job for us so stream parameter reaches to .snapshots() that returns a stream and rebuild builder whwnever this stream changes
                itemBuilder: (ctx, index) => Container(
                  padding: EdgeInsets.all(12),
                  child: MessgaeBubble(
                    documents[index]['text'],
                    documents[index]['userName'],
                    documents[index]['userId'] == futureSnapShot.data.uid
                        ? true
                        : false,
                    documents[index]['createdAt'],
                    documents[index]['userImage'],
                    key: ValueKey(documents[index]
                        .documentID), //el key dah 3ashan bs a void 2y bug mn el bayahslo fa 2y lIstView lw masaht haga msln haya msh hahtagha hna w msh hatfr2 awi bs ya3nii brdo , we won't see a difference here, but behind the scenes, this ensures that Flutter will always be able to efficiently render and update this list. It might not need that. It might be able to efficiently update this list even without the key, but it certainly also won't hurt.
                  ),
                ),

                itemCount: documents.length,
              );
            },
          );
        });
  }
}
