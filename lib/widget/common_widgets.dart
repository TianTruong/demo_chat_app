import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Chọn hình từ thư viện hoặc chụp ảnh
Widget buildImagePicker(
    {@required context, @required onTapCamera, @required onTapGallery}) {
  return SizedBox(
      height: 150,
      child: Column(children: [
        ListTile(
            leading: const Icon(Icons.camera_alt),
            title: Text(AppLocalizations.of(context)!.camera),
            onTap: onTapCamera),
        ListTile(
            leading: const Icon(Icons.image),
            title: Text(AppLocalizations.of(context)!.gallery),
            onTap: onTapGallery)
      ]));
}

// TextField
Widget buildTextFormField(
    {@required controller, @required hide, @required hintText}) {
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: TextFormField(
      obscureText: hide,
      controller: controller,
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.black, width: 5),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Color(0xFF08C187), width: 3)),
          hintText: hintText),
      keyboardType: TextInputType.text,
    ),
  );
}

// Detail Chat
Widget buildChat({@required friendName, @required message, @required onTap}) {
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.25),
                blurRadius: 5,
                offset: const Offset(0, 5))
          ]),
      child: ListTile(
          title: Text(friendName),
          subtitle: Text(message),
          trailing: const Icon(Icons.arrow_forward_ios_outlined),
          onTap: onTap),
    ),
  );
}

// Detail People
Widget buildPeople(
    {@required avatar, @required name, @required status, @required onTap}) {
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.25),
                blurRadius: 5,
                offset: const Offset(0, 5))
          ]),
      child: ListTile(
        leading: avatar != ''
            ? ClipOval(
                child: Image.network(
                  avatar,
                  fit: BoxFit.cover,
                  cacheHeight: 160,
                  cacheWidth: 160,
                ),
              )
            : ClipOval(
                child: Image.asset(
                  'images/bg.jpg',
                  fit: BoxFit.fill,
                  cacheHeight: 160,
                  cacheWidth: 160,
                ),
              ),
        title: Text(name),
        subtitle: Text(status),
        onTap: onTap,
      ),
    ),
  );
}
