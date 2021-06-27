import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:messenger/models/contacts_model.dart';
import 'package:messenger/utils/constants.dart';

class ScaleAndSlide extends StatelessWidget {
  const ScaleAndSlide({
    Key? key,
    required this.animation,
    required this.index,
    required List<RegisteredPhoneContacts> selected,
  })   : _selected = selected,
        super(key: key);
  final int index;
  final Animation<double> animation;
  final List<RegisteredPhoneContacts> _selected;

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      alignment: Alignment.center,
      scale: animation,
      child: Column(
        children: [
          Container(
            height: 70,
            width: 70,
            margin: EdgeInsets.only(left: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              image: DecorationImage(
                  image: CachedNetworkImageProvider(
                      _selected[index].user.photoUrl ??
                          GeneralConstants.DEFAULT_PHOTOURL),
                  fit: BoxFit.cover),
            ),
          ),
          Text(_selected[index].contact.givenName ??
              _selected[index].contact.displayName!),
        ],
      ),
    );
  }
}
