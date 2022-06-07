import 'package:flutter/material.dart';

class BottomDialog extends StatefulWidget {
  ///显示的内容
  List<String>? list;

  ///选中后回调
  Function(int)? onChanged;
  BottomDialog( {Key? key, this.list, this.onChanged}): super(key: key);

  @override
  State<BottomDialog> createState() => _BottomDialogState();
}

class _BottomDialogState extends State<BottomDialog> {
  final ScrollController _controller = ScrollController();
  double radius = 5;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _controller.animateTo(0 * 50, duration: const Duration(milliseconds: 1), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = (widget.list?.length ?? 0) * 50.0 + 50.0 + 20.0 + 20.0;
    if (height > MediaQuery.of(context).size.height) {
      height = MediaQuery.of(context).size.height;
    }

    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.transparent),
            width: double.infinity,
            height: height,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(radius),
                        color: Colors.white),
                    child: ListView.builder(
                      ///取消触底回弹
                      physics: const ClampingScrollPhysics(),
                      controller: _controller,
                      itemCount: widget.list?.length,
                      itemBuilder: (context, index) {
                        String title = widget.list![index];
                        Color? selectedColor = Colors.blue[500];

                        return GestureDetector(
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                height: 50,
                                width: double.infinity,
                                color: Colors.white,
                                child: Text(
                                  title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: selectedColor,
                                    fontSize: 20,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                              index == (widget.list?.length ?? 0) - 1
                                  ? Container()
                                  : Container(
                                      height: 1,
                                      width: double.infinity,
                                      color: Colors.grey[200],
                                    ),
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            widget.onChanged?.call(index);
                          },
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 60,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(radius),
                      color: Colors.white),
                  child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "取消",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          decoration: TextDecoration.none,
                        ),
                      )),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

bool isEmpty(Object? object) {
  if (object == null) return true;
  if (object is String && object.isEmpty) {
    return true;
  } else if (object is List && object.isEmpty) {
    return true;
  } else if (object is Map && object.isEmpty) {
    return true;
  }
  return false;
}

bool isNotEmpty(Object? object) {
  return !isEmpty(object);
}
