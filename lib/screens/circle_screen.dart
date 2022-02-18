import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/models/circle_member.dart';
import 'package:flutter_application_1/view_models/circle_view_model.dart';
import 'package:flutter_application_1/widgets/custom_col.dart';
import 'package:flutter_application_1/widgets/custom_icon.dart';
import 'package:flutter_application_1/widgets/custom_text_field.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

class CircleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Consumer<CircleViewModel>(
          builder: (_, circleViewModel, __) => Column(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0)),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10.0),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: BackButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      title: Text(
                        'Pick slot',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomIcon(
                          backgroundColor: Color(0xfffcf7e0),
                          iconColor: Colors.yellow[700],
                          icon: Icons.edit,
                          onPressed: () {
                            TextEditingController circleValueCon =
                                TextEditingController();
                            TextEditingController startDate =
                                TextEditingController();
                            TextEditingController endDate =
                                TextEditingController();
                            DateTime? startDateValue;
                            DateTime? endDateValue;

                            Future<DateTime?> getDate() async {
                              return await showDatePicker(
                                  context: context,
                                  initialDate: DateTime(2022),
                                  firstDate: DateTime(2022),
                                  lastDate: DateTime(2050));
                            }

                            showModalBottomSheet(
                                context: context,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(25.0))),
                                isScrollControlled: true,
                                builder: (ctx) {
                                  return Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      child: NotificationListener<
                                          OverscrollIndicatorNotification>(
                                        onNotification: (notification) {
                                          notification.disallowGlow();

                                          return true;
                                        },
                                        child: ListView(
                                          shrinkWrap: true,
                                          children: [
                                            const SizedBox(height: 10.0),
                                            CustomTextField(
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              title: 'Circle Value',
                                              controller: circleValueCon,
                                            ),
                                            const SizedBox(height: 10.0),
                                            CustomTextField(
                                              title: 'Start Date',
                                              readOnly: true,
                                              controller: startDate,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              onTap: () async {
                                                startDateValue =
                                                    await getDate();
                                                if (startDateValue != null) {
                                                  startDate.text =
                                                      intl.DateFormat.yMMMM()
                                                          .format(
                                                              startDateValue!);
                                                }
                                              },
                                            ),
                                            const SizedBox(height: 10.0),
                                            CustomTextField(
                                              readOnly: true,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              title: 'End Date',
                                              controller: endDate,
                                              onTap: () async {
                                                endDateValue = await getDate();
                                                if (endDateValue != null) {
                                                  endDate.text =
                                                      intl.DateFormat.yMMMM()
                                                          .format(
                                                              endDateValue!);
                                                }
                                              },
                                            ),
                                            const SizedBox(height: 10.0),
                                            TextButton(
                                              onPressed: () {
                                                if (startDateValue != null) {
                                                  circleViewModel.setStartDate =
                                                      startDateValue!;
                                                }
                                                if (endDateValue != null) {
                                                  circleViewModel.setEndDate =
                                                      endDateValue!;
                                                  print(
                                                      circleViewModel.endDate);
                                                }
                                                if (circleValueCon
                                                    .text.isNotEmpty) {
                                                  circleViewModel
                                                          .setCircleValue =
                                                      double.parse(
                                                          circleValueCon.text);
                                                }
                                                Navigator.pop(ctx);
                                              },
                                              child: Text(
                                                'Save',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .resolveWith((states) =>
                                                            Colors.green),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    ListTile(
                      leading: CustomIcon(
                        backgroundColor: Colors.blue[50],
                        iconColor: Colors.blue,
                        icon: FontAwesomeIcons.piggyBank,
                        iconSize: 20,
                        onPressed: () {},
                      ),
                      title: const Text(
                        'Circle Value',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${intl.NumberFormat.decimalPattern().format(circleViewModel.circleValue)} EGP',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomCol(
                            title: 'Pay',
                            subTitle: '2,500',
                          ),
                          CustomCol(
                            title: 'Duration',
                            subTitle:
                                '${(circleViewModel.endDate.difference(circleViewModel.startDate).inDays / 30).toStringAsFixed(0)} Month',
                          ),
                          CustomCol(
                            title: 'Starting',
                            subTitle:
                                '${intl.DateFormat.LLL().format(circleViewModel.startDate)} ${circleViewModel.startDate.year.toString().replaceFirst('20', '')}',
                          ),
                          CustomCol(
                            title: 'End',
                            subTitle:
                                '${intl.DateFormat.LLL().format(circleViewModel.endDate)} ${circleViewModel.endDate.year.toString().replaceFirst('20', '')}',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10.0),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GridView.builder(
                      physics: BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                      ),
                      itemCount: 20,
                      itemBuilder: (_, index) {
                        final List<CircleMember> circleMembers =
                            circleViewModel.circleMembers;
                        bool isFilled = circleMembers.isNotEmpty &&
                            circleMembers.length > index;
                        /* if (isFilled) {
                          return Column(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(30.0),
                                      child: Image.asset(
                                          circleMembers[index].memberImage),
                                    ),
                                    if (index < 3)
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        child: SizedBox(
                                          height: 50.0,
                                          width: 50.0,
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                                color: Colors.grey
                                                    .withOpacity(0.3)),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                'Jun 19',
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          );
                        } */
                        return GestureDetector(
                          onTap: () {
                            if (!isFilled) {
                              circleViewModel.addMember();
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isFilled && index < 3
                                  ? Colors.grey
                                  : !isFilled && index == 19
                                      ? Colors.green
                                      : Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (!isFilled)
                                  Icon(
                                    Icons.add_circle_outline,
                                    color: Colors.green[200],
                                  ),
                                if (isFilled)
                                  CircleAvatar(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30.0),
                                      child: Image.asset(
                                          circleMembers[index].memberImage),
                                    ),
                                  ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  'Jun 20',
                                  style: TextStyle(
                                    color: Colors.green[200],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
