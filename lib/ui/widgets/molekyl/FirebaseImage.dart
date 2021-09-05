import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loypa/data/provider/loypeProvider.dart';
import 'package:path/path.dart' as p;
import 'package:styled_widget/styled_widget.dart';

final firebaseStorageProvider =
    FutureProvider.family<String, String>((ref, url) async {
  return FirebaseStorage.instance.ref(url).getDownloadURL();
});

class FirebaseImage extends ConsumerWidget {
  FirebaseImage({
    Key? key,
    required this.path,
    required this.semanticsLabel,
    this.prefix = '',
    this.width,
    this.height,
    this.inkluderId = true,
    this.fit = BoxFit.contain,
    this.color,
    this.showLoader = true,
  }) : super(key: key);

  final String prefix;
  final String path;
  final bool inkluderId;

  final BoxFit fit;
  final Color? color;

  final double? width;
  final double? height;

  final bool showLoader;

  final String semanticsLabel;

  final spinner =
      (bool showLoader, double? width, double? height, String label) =>
          showLoader
              ? CircularProgressIndicator(
                  color: Colors.grey,
                  strokeWidth: 1,
                  semanticsLabel: label,
                )
                  .constrained(
                    width: width,
                    height: height,
                    maxWidth: 25,
                    maxHeight: 25,
                  )
                  .center()
              : SizedBox(
                  width: width ?? 25,
                  height: height ?? 25,
                );

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    String totalPath = '';

    if (inkluderId)
      totalPath += (context.read(loypeIdProvider).state ?? '') + '/';

    totalPath += prefix + path;

    final downloadURL = watch(firebaseStorageProvider(totalPath));

    return downloadURL.when(
      loading: () => spinner(showLoader, width, height, semanticsLabel),
      error: (_, __) => Icon(Icons.cloud_off_outlined),
      data: (url) {
        final filtype = p.extension(path);
        if (filtype == '.svg') {
          return SvgPicture.network(
            url,
            width: width,
            height: height,
            fit: fit,
            color: color,
            semanticsLabel: semanticsLabel,
            placeholderBuilder: (context) {
              return spinner(showLoader, width, height, semanticsLabel);
            },
          );
        }
        return Image.network(
          url,
          width: width,
          height: height,
          fit: fit,
          color: color,
          semanticLabel: semanticsLabel,
          errorBuilder: (context, _, __) {
            return Icon(Icons.cloud_off_outlined);
          },
        );
      },
    );
  }
}
