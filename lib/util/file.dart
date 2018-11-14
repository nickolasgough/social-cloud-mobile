import 'dart:io';


parseFilename(File imagefile) {
    List<String> path = imagefile.path.split("/");
    return path[path.length-1];
}
