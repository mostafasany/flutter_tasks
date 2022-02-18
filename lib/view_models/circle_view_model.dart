import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/models/circle_member.dart';

class CircleViewModel extends ChangeNotifier {
  double circleValue = 500000;
  List<CircleMember> _circleMembers = [
    CircleMember(
        date: DateTime(2021, 1),
        memberImage: 'assets/undraw_female_avatar_w3jk.png'),
    CircleMember(
        date: DateTime(2021, 1),
        memberImage: 'assets/undraw_male_avatar_323b.png'),
    CircleMember(
        date: DateTime(2021, 1),
        memberImage: 'assets/undraw_female_avatar_w3jk.png'),
    CircleMember(
        date: DateTime(2021, 1),
        memberImage: 'assets/undraw_male_avatar_323b.png'),
  ];
  List<CircleMember> get circleMembers => _circleMembers;
  DateTime startDate = DateTime(2022);
  DateTime endDate = DateTime(2022, 5);
  set setCircleValue(double value) {
    circleValue = value;
    notifyListeners();
  }

  set setStartDate(DateTime value) {
    startDate = value;
  }

  set setEndDate(DateTime value) {
    endDate = value;
  }

  addMember() {}
}
