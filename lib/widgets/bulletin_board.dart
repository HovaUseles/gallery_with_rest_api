import 'package:flutter/material.dart';
import 'package:gallery_with_rest_api/models/gallery_item.dart';

class DraggableItem {
  double height;
  double width;
  double scale;
  double rotation;
  double xPosition;
  double yPosition;
  Color color;
  Widget child;

  DraggableItem({
    required this.height,
    required this.rotation,
    required this.scale,
    required this.width,
    required this.xPosition,
    required this.yPosition,
    required this.child,
    required this.color
  });
}

class BulletinBoard extends StatefulWidget {
  final List<GalleryItem> galleryItems;
  
  const BulletinBoard({super.key, required this.galleryItems}) : super();

  @override
  _BulletinBoardState createState() => _BulletinBoardState();
}

class _BulletinBoardState extends State<BulletinBoard> {
  List<DraggableItem> draggableItems = [];
  late Offset _initPos;
  Offset _currentPos = Offset(0, 0);
  late double _currentScale;
  late double _currentRotation;
  late Size screen;

  @override
  void initState() {
    screen = Size(400, 500);
    for(int i = 0; i < widget.galleryItems.length; i++) {
      var galleryItem = widget.galleryItems.elementAt(i);
      draggableItems.add(DraggableItem(
          height: 200.0,
          width: 200.0,
          rotation: 0.0,
          scale: 1.0,
          xPosition: 0.1,
          yPosition: 0.1,
          color: Colors.red,
          child: Image.memory(galleryItem.imageBytes)
        ));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      height: MediaQuery.sizeOf(context).height,
      color: Colors.blue.withOpacity(0.8),
      width: MediaQuery.sizeOf(context).width,
      child: Stack(
        children: draggableItems.map((value) {
          return GestureDetector(
            onScaleStart: (details) {
              if (value == null) return;
              _initPos = details.focalPoint;
              _currentPos = Offset(value.xPosition, value.yPosition);
              _currentScale = value.scale;
              _currentRotation = value.rotation;
            },
            onScaleUpdate: (details) {
              if (value == null) return;
              final delta = details.focalPoint - _initPos;
              final left = (delta.dx / screen.width) + _currentPos.dx;
              final top = (delta.dy / screen.height) + _currentPos.dy;

              setState(() {
                value.xPosition = Offset(left, top).dx;
                value.yPosition = Offset(left, top).dy;
                value.rotation = details.rotation + _currentRotation;
                value.scale = details.scale * _currentScale;
              });
            },
            child: Stack(
              children: [
                Positioned(
                  left: value.xPosition * screen.width,
                  top: value.yPosition * screen.height,
                  child: Transform.scale(
                    scale: value.scale,
                    child: Transform.rotate(
                      angle: value.rotation,
                      child: Container(
                        height: value.height,
                        width: value.width,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Listener(
                            onPointerDown: (details) {
                              _initPos = details.position;
                              _currentPos =
                                  Offset(value.xPosition, value.yPosition);
                              _currentScale = value.scale;
                              _currentRotation = value.rotation;
                            },
                            onPointerUp: (details) {
                            },
                            // Shown Container
                            child: Container(
                              height: value.height,
                              width: value.width,
                              child: value.child,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}