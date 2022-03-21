import 'package:cAR/Pages/Gallery/photo_album.dart';
import 'package:cAR/Pages/Gallery/sources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhotoGallery extends StatefulWidget {
  const PhotoGallery({Key? key}) : super(key: key);

  @override
  State<PhotoGallery> createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Фото-галерея'),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
            fit: BoxFit.cover,
            image: ExactAssetImage('assets/gallery_background.jpg'),
          )),
          child: ListView.builder(
              itemCount: 6,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: CupertinoButton(
                      color: Colors.blue,
                      child: Text(PhotoGallerySources().albumTitles[index]),
                      onPressed: () {
                        switch (index) {
                          case 0:
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PhotoAlbum(
                                      len: 20,
                                      type: 'first',
                                    )));
                            break;
                          case 1:
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PhotoAlbum(
                                      len: 14,
                                      type: 'vospit',
                                    )));
                            break;
                          case 2:
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PhotoAlbum(
                                      len: 11,
                                      type: 'vipusknkiki',
                                    )));
                            break;
                          case 3:
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PhotoAlbum(
                                      len: 17,
                                      type: 'info',
                                    )));

                            break;
                          case 4:
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PhotoAlbum(
                                      len: 13,
                                      type: 'shvei',
                                    )));
                            break;
                          case 5:
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => PhotoAlbum(
                                      len: 10,
                                      type: 'textstyle',
                                    )));

                            break;
                          default:
                        }
                      }),
                );
              }),
        ));
  }
}
