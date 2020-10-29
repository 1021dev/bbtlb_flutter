
import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/provider/global.dart';
import 'package:big_bank_take_little_bank/screens/main/message/chat_cell.dart';
import 'package:big_bank_take_little_bank/widgets/app_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChatListScreen extends StatefulWidget {
  final MainScreenBloc screenBloc;
  final BuildContext homeContext;
  ChatListScreen({Key key, this.screenBloc, this.homeContext}) : super(key: key);

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  ChatScreenBloc chatScreenBloc;
  SlidableController slidableController;

  @override
  void initState() {
    slidableController = SlidableController(
      onSlideAnimationChanged: handleSlideAnimationChanged,
      onSlideIsOpenChanged: handleSlideIsOpenChanged,
    );
    chatScreenBloc = BlocProvider.of<ChatScreenBloc>(Global.instance.homeContext);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  void handleSlideAnimationChanged(Animation<double> slideAnimation) {
    setState(() {
    });
  }

  void handleSlideIsOpenChanged(bool isOpen) {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: chatScreenBloc,
      listener: (BuildContext context, ChatScreenState state) async {
        if (state is NotificationScreenSuccess) {
        } else if (state is ChatScreenFailure) {
          showCupertinoDialog(context: context, builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text('Oops'),
              content: Text(state.error),
              actions: [
                CupertinoDialogAction(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
        }
      },
      child: BlocBuilder<ChatScreenBloc, ChatScreenState>(
        cubit: chatScreenBloc,
        builder: (BuildContext context, ChatScreenState state) {
          return _body(state);
        },
      ),
    );
  }

  Widget _body(ChatScreenState state) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          child: Image.asset('assets/images/bg_top_bar_trans.png', fit: BoxFit.fill,),
        ),
        SafeArea(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 24,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Image.asset('assets/images/bg_message_top.png',),
              ),
             Positioned(
                top: 124,
                left: 24,
                right: 24,
                bottom: 24,
                child: state.messageList.length > 0 ? _notificationListWidget(state): Center(
                  child: Align(
                    alignment: Alignment.center,
                    child: AppLabel(
                      title: 'Currently you don\'t have any messages',
                      maxLine: 2,
                      alignment: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        state.isLoading ? Positioned(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Container(
            color: Colors.black12,
            child: SpinKitDoubleBounce(
              color: Colors.red,
              size: 50.0,
            ),
          ),
        ): Container(),
      ],
    );
  }

  Widget _notificationListWidget(ChatScreenState state) {
    return Container(
      child: ListView.separated(
        shrinkWrap: false,
        itemBuilder: (context, index) {
          return ChatCell(
            messageModel: state.messageList[index],
            controller: slidableController,
            onDelete: () {
              print('delete notifications');
              chatScreenBloc.add(DeleteChatEvent(messageModel: state.messageList[index]));
            },
            onTap: () {

            },
          );
        },
        separatorBuilder: (context, index) {
          return Divider(color: Colors.transparent,);
        },
        itemCount: state.messageList.length,
      ),
    );
  }

}
