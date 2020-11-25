
import 'package:big_bank_take_little_bank/blocs/bloc.dart';
import 'package:big_bank_take_little_bank/widgets/app_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DailyRewardsDialog extends StatefulWidget {
  final BuildContext homeContext;

  const DailyRewardsDialog({Key key, this.homeContext}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DailyRewardsDialogState(homeContext);
  }
}

class _DailyRewardsDialogState extends State<DailyRewardsDialog> {
  DailyRewardsBloc screenBloc;
  final BuildContext homeContext;
  _DailyRewardsDialogState(this.homeContext);

  @override
  void initState() {
    screenBloc = BlocProvider.of<DailyRewardsBloc>(homeContext);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DailyRewardsBloc, DailyRewardsState>(
      cubit: screenBloc,
      builder: (BuildContext context, DailyRewardsState state) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: _body(state),
        );
      },
    );
  }

  Widget _body(DailyRewardsAcceptState state) {
    double avatarSize = MediaQuery.of(context).size.width * 0.35;
    return SafeArea(
      child: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: EdgeInsets.all(16),
          child: Stack(
            alignment: Alignment.topCenter,
            fit: StackFit.expand,
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 25,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Color(0xff5c9d86),
                  ),
                  padding: EdgeInsets.all(8),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Color(0xff0b323b),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            color: Color(0xff204851),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppButtonLabel(
                                title: 'DAY ${state.rewardsModel.consecutive + 1}',
                                fontSize: 24,
                                shadow: true,
                              ),
                              AppButtonLabel(
                                title: 'REWARD',
                                fontSize: 24,
                                shadow: true,
                                color: Color(0xff70a4b1),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12,),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: Color(0x47000000),
                            ),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Positioned(
                                  bottom: 0,
                                  height: 100,
                                  left: 8,
                                  right: 8,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(9),
                                      color: Color(0x20000000),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  child: Image.asset('assets/images/popup.png'),
                                ),
                                Positioned(
                                  bottom: 44,
                                  width: MediaQuery.of(context).size.width * 0.5,
                                  child: Container(
                                    child: Image.asset('assets/images/ic_earn.png'),
                                  ),
                                ),
                                Positioned(
                                  bottom: 64,
                                  child: AppBorderLabel(
                                    title: '\$${state.rewardsModel.rewardPoint}',
                                    fontFamily: 'Lucky',
                                    color: Color(0xfff1d700),
                                    fontSize: 100,
                                    borderWidth: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: BackgroundButton(
                  height: 64,
                  width: 734 / 193 * 64,
                  title: 'ACCEPT',
                  fontSize: 24,
                  shadow: true,
                  shadowColor: Color(0x80000000),
                  onTap: () {
                    screenBloc.add(UpdateDailyRewards(rewardsModel: state.rewardsModel));
                    Future.delayed(Duration(microseconds: 300), () {
                      Navigator.pop(context);
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
