import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoViewWrapper extends StatefulWidget {
  final int index;
  final List<String> items;
  final PageController pageController;

  PhotoViewWrapper({
    Key? key,
    this.index = 0,
    required this.items,
  }) : pageController = PageController(initialPage: index), super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PhotoViewWrapperState();
  }
}

class _PhotoViewWrapperState extends State<PhotoViewWrapper> {
  late int currentIndex = widget.index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(onPressed:(){
            Navigator.pop(context);
          },icon:const Icon(Icons.close)),
          backgroundColor:Colors.black
      ),
      body: Container(
        decoration: const BoxDecoration( color: Colors.black, ),
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: _buildItem,
              itemCount: widget.items.length,
              backgroundDecoration: const BoxDecoration( color: Colors.black, ),
              pageController: widget.pageController,
              onPageChanged: onPageChanged,
              scrollDirection: Axis.horizontal,
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "${currentIndex + 1}/${widget.items.length}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  decoration: null,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final String item = widget.items[index];
    return PhotoViewGalleryPageOptions(
      imageProvider: getImageProvider(item),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 4.1,
    );
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  ImageProvider getImageProvider(String path){
    if(path.startsWith("http")){
      return NetworkImage(path);
    }else{
      return FileImage(File(path));
    }
  }

}