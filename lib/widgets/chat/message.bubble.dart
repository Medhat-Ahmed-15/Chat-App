import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessgaeBubble extends StatelessWidget {
  final String message;
  Key key;
  final bool isMe;
  final String userName;
  final Timestamp timeStamp;
  final String userImageUrl;
  MessgaeBubble(
    this.message,
    this.userName,
    this.isMe,
    this.timeStamp,
    this.userImageUrl, {
    this.key,
  });
  @override
  Widget build(BuildContext context) {
    DateTime time = timeStamp.toDate();
    String messagetime = DateFormat("hh:mm").format(time);

    return Stack(
      children: [
        Row(
          //ana 3mlt wrapping hna bal row 3ahsan 2a2dr a put ek messages fal most right 2w el most left 3ala hasb el sender w el receiver w brdo 3ashan el width bata3 el container doesn't have any effect toul ma howa mahttot gowa listView w ahh listView 3ashan el message bubble dee kolha mahtoota gowa list view🙂
          mainAxisAlignment:
              isMe == true ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: isMe == true
                      ? Colors.grey[300]
                      : Theme.of(context).accentColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft: isMe ? Radius.circular(12) : Radius.circular(0),
                    bottomRight:
                        isMe ? Radius.circular(0) : Radius.circular(12),
                  )),
              width: 140,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    messagetime,
                    style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
                  ),
                  Flexible(
                    child: Column(
                        crossAxisAlignment: isMe == true
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(userName,
                              textAlign: isMe == true
                                  ? TextAlign.end
                                  : TextAlign.start,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 10,
                                  color: isMe == true
                                      ? Colors.black
                                      : Theme.of(context)
                                          .accentTextTheme
                                          .headline1
                                          .color)),
                          SizedBox(height: 5),
                          Text(
                            message,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isMe == true
                                    ? Colors.black
                                    : Theme.of(context)
                                        .accentTextTheme
                                        .headline1
                                        .color),
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
            top: -10,
            left: isMe ? null : 130,
            right: isMe ? 130 : null,
            child: CircleAvatar(
              backgroundImage: NetworkImage(userImageUrl),
            ))
      ],
      overflow: Overflow
          .visible, //dee 3ashan lama 2a3rf el image up w tatla3 bara el stack mayat3amalahash clip
    );
  }
}
