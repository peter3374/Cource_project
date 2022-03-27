import 'package:cAR/Widgets/CustomButton.dart';
import 'package:flutter/material.dart';

class PhotoAlbum extends StatelessWidget {
  String? type;
  int? len;
  PhotoAlbum({Key? key, this.type, this.len}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LimitedBox(
          maxHeight: 400,
          maxWidth: 200,
          child: PageView.builder(
              physics: const ClampingScrollPhysics(),
              itemCount: len,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Center(
                  child: InteractiveViewer(
                    maxScale: 4,
                    child: Container(
                      height: 500,
                      width: 350,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: ExactAssetImage(
                                  'assets/gallery/$type/${index + 1}.jpg')),
                          color: Colors.black45,
                          border: Border.all(color: Colors.blue, width: 3),
                          borderRadius: BorderRadius.circular(9)),
                    ),
                  ),
                );
              }),
        ),
        CustomAuthButton(
            text: 'Назад',
            method: () {
              Navigator.of(context).pop();
            },
            icon: Icons.arrow_back_ios_new),
      ],
    ));
  }
}
