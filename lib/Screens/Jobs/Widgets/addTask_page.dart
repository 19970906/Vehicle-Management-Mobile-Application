import 'package:flutter/material.dart';

class AddJobTaskPage extends StatefulWidget {
  const AddJobTaskPage({Key? key}) : super(key: key);

  @override
  _AddJobTaskPageState createState() => _AddJobTaskPageState();
}

class Task {
  final String time;
  final String task;
  final String desc;
  final bool isFinish;

  const Task(this.time, this.task, this.desc, this.isFinish);
}

final List<Task> _taskList = [
  const Task("Task 1", "Full Body wash", "Completed", true),
  const Task("Task 2", "Replacing Breal Liners", "Completed", true),
  const Task("Task 3", "Changing SIgnal Lights", "On Progress", false),
  const Task("Task 4", "Check wheel alignment", "Not Started", false),
  const Task("Task 5", "Check wheel alignment", "Not Started", false),
  const Task("Task 6", "Check wheel alignment", "Not Started", false),
];

class _AddJobTaskPageState extends State<AddJobTaskPage> {
  double iconSize = 20;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _taskList.length,
      padding: const EdgeInsets.all(0),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Row(
            children: <Widget>[
              Container(
                decoration: CustomIconDecoration(
                    iconSize: iconSize, lineWidth: 1, firstData: index == 0 ?? true, lastData: index == _taskList.length - 1 ?? true),
                child: Container(
                  decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50)), boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 3),
                      color: Color(0x20000000),
                      blurRadius: 5,
                    )
                  ]),
                  child: Icon(
                    _taskList[index].isFinish ? Icons.fiber_manual_record : Icons.radio_button_unchecked,
                    size: iconSize,
                    color: const Color(0xFFef5350),
                  ),
                ),
              ),
              SizedBox(
                  width: 80,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(_taskList[index].time),
                  )),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                  child: Container(
                    padding: const EdgeInsets.all(14.0),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        boxShadow: [BoxShadow(color: Color(0x20000000), blurRadius: 5, offset: Offset(0, 3))]),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                      Text(_taskList[index].task),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(_taskList[index].desc),
                    ]),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class CustomIconDecoration extends Decoration {
  final double iconSize;
  final double lineWidth;
  final bool firstData;
  final bool lastData;

  const CustomIconDecoration({
    required double iconSize,
    required double lineWidth,
    required bool firstData,
    required bool lastData,
  })  : iconSize = iconSize,
        lineWidth = lineWidth,
        firstData = firstData,
        lastData = lastData;

  @override
  BoxPainter createBoxPainter([Function()? onChanged]) {
    return IconLine(iconSize: iconSize, lineWidth: lineWidth, firstData: firstData, lastData: lastData);
  }
}

class IconLine extends BoxPainter {
  final double iconSize;
  final bool firstData;
  final bool lastData;

  final Paint paintLine;

  IconLine({
    required double iconSize,
    required double lineWidth,
    required bool firstData,
    required bool lastData,
  })  : iconSize = iconSize,
        firstData = firstData,
        lastData = lastData,
        paintLine = Paint()
          ..color = Colors.red
          ..strokeCap = StrokeCap.round
          ..strokeWidth = lineWidth
          ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final leftOffset = Offset((iconSize / 2) + 20, offset.dy);
    final double iconSpace = iconSize / 1.8;

    final Offset top = configuration.size!.topLeft(Offset(leftOffset.dx, 0.0));
    final Offset centerTop = configuration.size!.centerLeft(Offset(leftOffset.dx, leftOffset.dy - iconSpace));

    final Offset centerBottom = configuration.size!.centerLeft(Offset(leftOffset.dx, leftOffset.dy + iconSpace));
    final Offset end = configuration.size!.bottomLeft(Offset(leftOffset.dx, leftOffset.dy * 2));

    if (!firstData) canvas.drawLine(top, centerTop, paintLine);
    if (!lastData) canvas.drawLine(centerBottom, end, paintLine);
  }
}
