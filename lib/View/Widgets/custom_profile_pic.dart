import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qplay/Helper/functions.dart';

import '../../Helper/app_const.dart';

/// Displays a circular user avatar.
///
/// Loads the image from [url] (a relative path that is combined with the
/// base API URL via [fileUrl]).  If the URL is empty or fails to load, a
/// fallback circle with the first letter of [name] is shown instead.
/// [size] controls the diameter of the avatar in logical pixels.
class CustomProfilePic extends StatelessWidget {
  const CustomProfilePic(
      {super.key,
        required this.url,
        required this.size,
        required this.name,

      });
  final String url;
  final double size;
  final String name;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: !url.isNum
          ? Container(
            color: Get.isDarkMode
            ? const Color(0xff3F3F3F)
            : const Color(0xffE5E5E5),
              width: size,
              height: size,
              child: Image.network(
                fileUrl(url),
                fit: BoxFit.cover,
                headers: {
                  'Authorization': 'Bearer ${AppConst.prefs.getString('token')}'
                },
              ),
            )
          : Container(
              width: size,
              height: size,
              color: Color(int.parse(url)),
              child: Center(
                child: Text(
                  name[0],
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: size > 50 ? 20 : 16
                  ),
                ),
              ),
            ),
    );
  }
}
