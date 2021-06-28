import 'package:flutter/widgets.dart';

///
class StickerAsset {
  ///
  const StickerAsset({
    required this.id,
    required this.sticker,
    this.angle = 0.0,
    this.constraint = const StickerConstraint(),
    this.position = const StickerPosition(),
    this.size = const StickerSize(),
  });

  ///
  final String id;

  ///
  final Sticker sticker;

  ///
  final double angle;

  ///
  final StickerConstraint constraint;

  ///
  final StickerPosition position;

  ///
  final StickerSize size;

  ///
  StickerAsset copyWith({
    Sticker? sticker,
    double? angle,
    StickerConstraint? constraint,
    StickerPosition? position,
    StickerSize? size,
  }) {
    return StickerAsset(
      id: id,
      sticker: sticker ?? this.sticker,
      angle: angle ?? this.angle,
      constraint: constraint ?? this.constraint,
      position: position ?? this.position,
      size: size ?? this.size,
    );
  }
}

///
class StickerConstraint {
  ///
  const StickerConstraint({this.width = 1, this.height = 1});

  ///
  final double width;

  ///
  final double height;
}

///
class StickerSize {
  ///
  const StickerSize({this.width = 1, this.height = 1});

  ///
  final double width;

  ///
  final double height;
}

///
class StickerPosition {
  ///
  const StickerPosition({this.dx = 0, this.dy = 0});

  ///
  final double dx;

  ///
  final double dy;
}

/// {@template asset}
/// A Dart object which holds metadata for a given sticker.
/// {@endtemplate}
class Sticker {
  /// {@macro asset}
  const Sticker({
    this.name,
    this.path,
    this.size = const Size(200.0, 200.0),
    this.pathType = StickerPathType.none,
    this.widget,
  });

  /// The name of the sticker.
  final String? name;

  /// The url of the sticker. either network/accets or text
  final String? path;

  ///
  final StickerPathType pathType;

  /// The size of the asset. Default Size(100.0, 100.0)
  final Size size;

  ///
  final Widget? widget;
}

///
enum StickerPathType {
  ///
  text,

  ///
  networkImg,

  ///
  assetsImage,

  ///
  none,
}

///
const gifs = {
  Sticker(
    name: 'No Way',
    path: 'https://media.giphy.com/media/USUIWSteF8DJoc5Snd/giphy.gif',
    pathType: StickerPathType.networkImg,
  ),
  Sticker(
    name: 'Sad Face',
    path: 'https://media.giphy.com/media/h4OGa0npayrJX2NRPT/giphy.gif',
    pathType: StickerPathType.networkImg,
  ),
  Sticker(
    name: 'Angry Face',
    path: 'https://media.giphy.com/media/j5E5qvtLDTfmHbT84Y/giphy.gif',
    pathType: StickerPathType.networkImg,
  ),
  Sticker(
    name: 'Sad Miss You',
    path: 'https://media.giphy.com/media/IzcFv6WJ4310bDeGjo/giphy.gif',
    pathType: StickerPathType.networkImg,
  ),
  Sticker(
    name: 'Angry Face',
    path: 'https://media.giphy.com/media/kyQfR7MlQQ9Gb8URKG/giphy.gif',
    pathType: StickerPathType.networkImg,
  ),
  Sticker(
    name: 'Smiley Face Love',
    path: 'https://media.giphy.com/media/hof5uMY0nBwxyjY9S2/giphy.gif',
    pathType: StickerPathType.networkImg,
  ),
  Sticker(
    name: 'Sad Face',
    path: 'https://media.giphy.com/media/kfS15Gnvf9UhkwafJn/giphy.gif',
    pathType: StickerPathType.networkImg,
  ),
  Sticker(
    name: 'Crying',
    path: 'https://media.giphy.com/media/ViHbdDMcIOeLeblrbq/giphy.gif',
    pathType: StickerPathType.networkImg,
  ),
  Sticker(
    name: 'Wow',
    path: 'https://media.giphy.com/media/XEyXIfu7IRQivZl1Mw/giphy.gif',
    pathType: StickerPathType.networkImg,
  ),
  Sticker(
    name: 'Fuckboy',
    path: 'https://media.giphy.com/media/Kd5vjqlBqOhLsu3Rna/giphy.gif',
    pathType: StickerPathType.networkImg,
  ),
  Sticker(
    name: 'Bless You',
    path: 'https://media.giphy.com/media/WqR7WfQVrpXNcmrm81/giphy.gif',
    pathType: StickerPathType.networkImg,
  ),
  Sticker(
    name: 'As If Whatever',
    path: 'https://media.giphy.com/media/Q6xFPLfzfsgKoKDV60/giphy.gif',
    pathType: StickerPathType.networkImg,
  ),
  Sticker(
    name: 'Sick face',
    path: 'https://media.giphy.com/media/W3CLbW0KY3RtjsqtYO/giphy.gif',
    pathType: StickerPathType.networkImg,
  ),
  Sticker(
    name: 'Birthday cake',
    path: 'https://media.giphy.com/media/l4RS2PG61HIYiukdoT/giphy.gif',
    pathType: StickerPathType.networkImg,
  ),
  Sticker(
    name: 'Embarrassed Face',
    path: 'https://media.giphy.com/media/kyzzHEoaLAAr9nX4fy/giphy.gif',
    pathType: StickerPathType.networkImg,
  ),
  Sticker(
    name: 'Celebrate Happy Birthday',
    path: 'https://media.giphy.com/media/7zSBoGW2VoCEzWVjyA/giphy.gif',
    pathType: StickerPathType.networkImg,
  ),
  Sticker(
    name: 'Effects ',
    path: 'https://media.giphy.com/media/xT0GqKaASLordVtYCk/giphy.gif',
    pathType: StickerPathType.networkImg,
  ),
};

///
const arts = {
  Sticker(
    name: 'Multiple circles',
    path:
        'https://static.vecteezy.com/system/resources/previews/001/192/216/original/circle-png.png',
    pathType: StickerPathType.networkImg,
  ),
  Sticker(
    name: 'Red color',
    path:
        'https://www.pngarts.com/files/2/Blood-Red-Smoke-PNG-Background-Image.png',
    pathType: StickerPathType.networkImg,
  ),
  Sticker(
    name: 'Flowers',
    path: 'https://freepngimg.com/thumb/vector/5-2-vector-high-quality-png.png',
    pathType: StickerPathType.networkImg,
  ),
  // Sticker(
  //   name: 'Multiple colors splash',
  //   path:
  //       ' https://img.pngio.com/millions-of-png-images-backgrounds-and-vectors-for-free-download-holi-background-png-640_640.png',
  //   pathType: StickerPathType.networkImg,
  // ),
  Sticker(
    name: 'Circle drops',
    path:
        'https://www.freepnglogos.com/uploads/bubbles-png/bubbles-png-transparent-image-pngpix-4.png',
    pathType: StickerPathType.networkImg,
  ),
  Sticker(
    name: 'Eagle Wings',
    path: 'https://www.freeiconspng.com/uploads/angel-png-1.png',
    pathType: StickerPathType.networkImg,
  ),
  Sticker(
    name: 'Cloud',
    path:
        'https://i.pinimg.com/originals/19/8d/ae/198daeda14097d45e417e62ff283f10e.png',
    pathType: StickerPathType.networkImg,
  ),
  Sticker(
    name: 'Wings',
    path:
        'https://cdn.pixabay.com/photo/2017/07/04/23/41/white-wings-2473023__480.png',
    pathType: StickerPathType.networkImg,
  ),
  Sticker(
    name: 'Abstract art',
    path:
        'https://freepngimg.com/download/graphic/53280-2-abstract-art-hd-free-png-hq.png',
    pathType: StickerPathType.networkImg,
  ),
  Sticker(
    name: 'Love hearts',
    path: 'https://www.pngarts.com/files/4/Love-Heart-PNG-Free-Download.png',
    pathType: StickerPathType.networkImg,
  ),
  Sticker(
    name: 'Hair',
    path:
        'https://cdn.statically.io/img/kreditings.com/wp-content/uploads/2020/09/hair-png.png?quality=100&f=auto',
    pathType: StickerPathType.networkImg,
  ),
  Sticker(
    name: 'Hair',
    path:
        'https://i.pinimg.com/originals/df/8b/f1/df8bf1a18047ff20d3f82e0f47dbe683.png',
    pathType: StickerPathType.networkImg,
  ),
  Sticker(
    name: 'Hair',
    path:
        'https://i.dlpng.com/static/png/1357097-cb-hair-png-hair-png-521_500_preview.png',
    pathType: StickerPathType.networkImg,
  ),
  Sticker(
    name: '',
    path: 'https://freepngimg.com/thumb/hair/21-women-hair-png-image-thumb.png',
    pathType: StickerPathType.networkImg,
  ),
  Sticker(
    name: 'Hair',
    path: 'https://pngimg.com/uploads/hair/hair_PNG5637.png',
    pathType: StickerPathType.networkImg,
  ),
  Sticker(
    name: 'Hair',
    path: 'https://www.pngarts.com/files/4/Picsart-PNG-Background-Image.png',
    pathType: StickerPathType.networkImg,
  ),
  Sticker(
    name: 'Color splash',
    path: 'https://pngimage.net/wp-content/uploads/2018/06/png-arts-6.png',
    pathType: StickerPathType.networkImg,
  ),
  // Sticker(
  //   name: 'Smoke',
  //   path:
  //       ' https://i.dlpng.com/static/png/6242591-pink-smoke-png-background-image-png-arts-pink-smoke-png-738_733_preview.png',
  //   pathType: StickerPathType.networkImg,
  // ),
  Sticker(
    name: 'Colors',
    path: 'https://pngimage.net/wp-content/uploads/2018/05/colors-png-1.png',
    pathType: StickerPathType.networkImg,
  ),
  Sticker(
    name: 'Art',
    path: 'https://i.dlpng.com/static/png/6719469_preview.png',
    pathType: StickerPathType.networkImg,
  ),
  Sticker(
    name: 'Paint splatter',
    path:
        'https://pngimage.net/wp-content/uploads/2018/06/paint-splatter-png-6.png',
    pathType: StickerPathType.networkImg,
  ),
  Sticker(
    name: 'Quincea',
    path:
        'https://pngimage.net/wp-content/uploads/2018/06/vector-quincea%C3%B1era-png-1.png',
    pathType: StickerPathType.networkImg,
  ),
  Sticker(
    name: 'Red lines',
    path:
        'https://www.downloadclipart.net/large/red-abstract-lines-png-image.png',
    pathType: StickerPathType.networkImg,
  ),
  Sticker(
    name: 'Smoke',
    path:
        'https://pngimage.net/wp-content/uploads/2018/06/%D1%87%D0%B5%D1%80%D0%BD%D1%8B%D0%B9-%D0%B4%D1%8B%D0%BC-png-2.png',
    pathType: StickerPathType.networkImg,
  ),
  Sticker(
    name: 'Eagle',
    path:
        'https://www.pngkey.com/png/full/0-9646_american-eagle-logo-png-eagle-holding-lombardi-trophy.png',
    pathType: StickerPathType.networkImg,
  ),
  Sticker(
    name: 'Bird',
    path:
        'https://storage.needpix.com/rsynced_images/no-background-2997564_1280.png',
    pathType: StickerPathType.networkImg,
  ),
  Sticker(
    name: 'Eagle',
    path:
        'https://cdn.pixabay.com/photo/2017/12/13/23/27/no-background-3017971_1280.png',
    pathType: StickerPathType.networkImg,
  ),
};