{
  mime,
}:
let
  inherit (mime)
    archive
    audio
    browser
    calendar
    connect
    #ebook
    email
    files
    image
    pdf
    text
    video
    ;
in
{
  # Archive
  "application/arj" = archive;
  "application/gzip" = archive;
  "application/vnd.ms-cab-compressed" = archive;
  "application/vnd.rar" = archive;
  "application/x-7z-compressed" = archive;
  "application/x-7z-compressed-tar" = archive;
  "application/x-ace" = archive;
  "application/x-alz" = archive;
  "application/x-ar" = archive;
  "application/x-arj" = archive;
  "application/x-archive" = archive;
  "application/x-bcpio" = archive;
  "application/x-bzip" = archive;
  "application/x-bzip-compressed-tar" = archive;
  "application/x-bzip1" = archive;
  "application/x-bzip1-compressed-tar" = archive;
  "application/x-bzip2" = archive;
  "application/x-bzip2-compressed-tar" = archive;
  "application/x-cabinet" = archive;
  "application/x-cd-image" = archive;
  "application/x-compress" = archive;
  "application/x-compressed-tar" = archive;
  "application/x-cpio" = archive;
  "application/x-cpio-compressed" = archive;
  "application/x-deb" = archive;
  "application/x-ear" = archive;
  "application/x-gtar" = archive;
  "application/x-gzip" = archive;
  "application/x-iso9660-appimage" = archive;
  "application/x-lha" = archive;
  "application/x-lhz" = archive;
  "application/x-lrzip" = archive;
  "application/x-lrzip-compressed-tar" = archive;
  "application/x-lz4" = archive;
  "application/x-lz4-compressed-tar" = archive;
  "application/x-lzip" = archive;
  "application/x-lzip-compressed-tar" = archive;
  "application/x-lzma" = archive;
  "application/x-lzma-compressed-tar" = archive;
  "application/x-lzop" = archive;
  "application/x-lzop-compressed-tar" = archive;
  "application/x-rar" = archive;
  "application/x-rar-compressed" = archive;
  "application/x-rpm" = archive;
  "application/x-rzip" = archive;
  "application/x-source-rpm" = archive;
  "application/x-stuffit" = archive;
  "application/x-sv4cpio" = archive;
  "application/x-sv4crc" = archive;
  "application/x-tar" = archive;
  "application/x-tarz" = archive;
  "application/x-tzo" = archive;
  "application/x-war" = archive;
  "application/x-xar" = archive;
  "application/x-xz" = archive;
  "application/x-xz-compressed-tar" = archive;
  "application/x-zstd-compressed-tar" = archive;
  "application/x-zip" = archive;
  "application/x-zip-compressed" = archive;
  "application/x-zoo" = archive;
  "application/zip" = archive;
  "application/zlib" = archive;
  "application/zstd" = archive;
  "multipart/x-zip" = archive;

  # Audio
  "audio/3gpp" = audio;
  "audio/3gpp2" = audio;
  "audio/aac" = audio;
  "audio/ac3" = audio;
  "audio/amr" = audio;
  "audio/amr-wb" = audio;
  "audio/basic" = audio;
  "audio/dv" = audio;
  "audio/eac3" = audio;
  "audio/flac" = audio;
  "audio/m4a" = audio;
  "audio/midi" = audio;
  "audio/mp1" = audio;
  "audio/mp2" = audio;
  "audio/mp3" = audio;
  "audio/mp4" = audio;
  "audio/mpeg" = audio;
  "audio/mpegurl" = audio;
  "audio/mpg" = audio;
  "audio/ogg" = audio;
  "audio/opus" = audio;
  "audio/rn-mpeg" = audio;
  "audio/scpls" = audio;
  "audio/vnd.dolby.heaac.1" = audio;
  "audio/vnd.dolby.heaac.2" = audio;
  "audio/vnd.dolby.mlp" = audio;
  "audio/vnd.dts" = audio;
  "audio/vnd.dts.hd" = audio;
  "audio/vnd.rn-realaudio" = audio;
  "audio/vnd.wave" = audio;
  "audio/vorbis" = audio;
  "audio/wav" = audio;
  "audio/webm" = audio;
  "audio/x-aac" = audio;
  "audio/x-aiff" = audio;
  "audio/x-ape" = audio;
  "audio/x-flac" = audio;
  "audio/x-gsm" = audio;
  "audio/x-it" = audio;
  "audio/x-m4a" = audio;
  "audio/x-matroska" = audio;
  "audio/x-mod" = audio;
  "audio/x-mp1" = audio;
  "audio/x-mp2" = audio;
  "audio/x-mp3" = audio;
  "audio/x-mpeg" = audio;
  "audio/x-mpegurl" = audio;
  "audio/x-mpg" = audio;
  "audio/x-ms-asf" = audio;
  "audio/x-ms-wma" = audio;
  "audio/x-musepack" = audio;
  "audio/x-oggflac" = audio;
  "audio/x-pls" = audio;
  "audio/x-pn-aiff" = audio;
  "audio/x-pn-au" = audio;
  "audio/x-pn-realaudio" = audio;
  "audio/x-pn-wav" = audio;
  "audio/x-real-audio" = audio;
  "audio/x-realaudio" = audio;
  "audio/x-s3m" = audio;
  "audio/x-scpls" = audio;
  "audio/x-shorten" = audio;
  "audio/x-speex" = audio;
  "audio/x-tta" = audio;
  "audio/x-vorbis" = audio;
  "audio/x-vorbis+ogg" = audio;
  "audio/x-wav" = audio;
  "audio/x-wavpack" = audio;
  "audio/x-xm" = audio;

  # Browser
  "x-scheme-handler/http" = browser;
  "x-scheme-handler/https" = browser;

  # Calendar
  "application/x-extension-ics" = calendar;
  "text/calendar" = calendar;
  "x-scheme-handler/webcal" = calendar;
  "x-scheme-handler/webcals" = calendar;

  # Email
  "message/rfc822" = email;
  "x-scheme-handler/mailto" = email;
  "x-scheme-handler/mid" = email;

  # File Manager
  "inode/directory" = files;

  # Image
  "image/avif" = image;
  "image/bmp" = image;
  "image/gif" = image;
  "image/heic" = image;
  "image/heif" = image;
  "image/jpeg" = image;
  "image/jpg" = image;
  "image/jxl" = image;
  "image/pjpeg" = image;
  "image/png" = image;
  "image/svg+xml" = image;
  "image/svg+xml-compressed" = image;
  "image/tiff" = image;
  "image/vnd.radiance" = image;
  "image/vnd.wap.wbmp" = image;
  "image/vnd-ms.dds" = image;
  "image/webp" = image;
  "image/x-bmp" = image;
  "image/x-dds" = image;
  "image/x-eps" = image;
  "image/x-exr" = image;
  "image/x-gray" = image;
  "image/x-icb" = image;
  "image/x-icns" = image;
  "image/x-ico" = image;
  "image/x-icon" = image;
  "image/x-pcx" = image;
  "image/x-png" = image;
  "image/x-portable-anymap" = image;
  "image/x-portable-bitmap" = image;
  "image/x-portable-graymap" = image;
  "image/x-portable-pixmap" = image;
  "image/x-qoi" = image;
  "image/x-tga" = image;
  "image/x-xbitmap" = image;
  "image/x-xcf" = image;
  "image/x-xpixmap" = image;
  "image/x-webp" = image;

  # GS/KDE-Connect
  "x-scheme-handler/sms" = connect;
  "x-scheme-handler/tel" = connect;

  # PDF / Reader
  #"application/epub+zip" = ebook;
  #"application/ereader" = ebook;
  "application/pdf" = pdf;
  "application/x-cb7" = pdf;
  "application/x-cbc" = pdf;
  "application/x-cbr" = pdf;
  "application/x-cbt" = pdf;
  "application/x-cbz" = pdf;

  # Text
  "text/plain" = text;

  # Video
  "application/x-matroska" = video;
  "video/3gp" = video;
  "video/3gpp" = video;
  "video/3gpp2" = video;
  "video/avi" = video;
  "video/divx" = video;
  "video/dv" = video;
  "video/fli" = video;
  "video/flv" = video;
  "video/mp2t" = video;
  "video/mp4" = video;
  "video/mp4v-es" = video;
  "video/mpeg" = video;
  "video/mpeg-system" = video;
  "video/msvideo" = video;
  "video/ogg" = video;
  "video/quicktime" = video;
  "video/vnd.avi" = video;
  "video/vnd.divx" = video;
  "video/vnd.mpegurl" = video;
  "video/vnd.rn-realvideo" = video;
  "video/webm" = video;
  "video/x-avi" = video;
  "video/x-flc" = video;
  "video/x-fli" = video;
  "video/x-flic" = video;
  "video/x-flv" = video;
  "video/x-m4v" = video;
  "video/x-matroska" = video;
  "video/x-mpeg" = video;
  "video/x-mpeg2" = video;
  "video/x-mpeg-system" = video;
  "video/x-ms-afs" = video;
  "video/x-ms-asf" = video;
  "video/x-ms-wm" = video;
  "video/x-ms-wmv" = video;
  "video/x-ms-wmx" = video;
  "video/x-ms-wvxvideo" = video;
  "video/x-msvideo" = video;
  "video/x-nsv" = video;
  "video/x-ogm" = video;
  "video/x-ogm+ogg" = video;
  "video/x-theora" = video;
  "video/x-theora+ogg" = video;
}
