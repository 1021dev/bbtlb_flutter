import 'package:big_bank_take_little_bank/firestore_service/firestore_service.dart';
import 'package:big_bank_take_little_bank/models/comment_model.dart';
import 'package:big_bank_take_little_bank/provider/global.dart';
import 'package:big_bank_take_little_bank/widgets/profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentCell extends StatelessWidget {
  final CommentModel commentModel;
  CommentCell({this.commentModel});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirestoreService().getUserWithId(commentModel.userId),
      builder: (context, snapshot) {
        if (commentModel.userId == Global.instance.userId) {
          return Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 44,),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Color(0xff1B505E),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xFF256979),
                      ),
                      padding: EdgeInsets.all(6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  timeago.format(commentModel.createdAt),
                                  style: TextStyle(
                                    fontFamily: 'BackToSchool',
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  commentModel.userName,
                                  style: TextStyle(
                                    fontFamily: 'BackToSchool',
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            commentModel.comment,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontFamily: 'BackToSchool',
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8,),
                ProfileAvatar(
                  image: snapshot.data != null ? snapshot.data.image ?? '': '',
                  avatarSize: 50,
                ),
              ],
            ),
          );
        } else {
          return Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileAvatar(
                  image: snapshot.data != null ? snapshot.data.image ?? '': '',
                  avatarSize: 50,
                ),
                SizedBox(width: 8,),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Color(0xff1B505E),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color(0xFF256979),
                      ),
                      padding: EdgeInsets.all(6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  commentModel.userName,
                                  style: TextStyle(
                                    fontFamily: 'BackToSchool',
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  timeago.format(commentModel.createdAt),
                                  style: TextStyle(
                                    fontFamily: 'BackToSchool',
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            commentModel.comment,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontFamily: 'BackToSchool',
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 44,),
              ],
            ),
          );
        }
      },
    );
  }
}