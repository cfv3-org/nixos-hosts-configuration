{ pkgs, ... }:

{
  home.packages = with pkgs; [
    libreoffice-qt-fresh

    hunspell
    hunspellDicts.ru_RU
    hunspellDicts.en_US
    hunspellDicts.de_DE
    hyphen
    hyphenDicts.ru_RU
    hyphenDicts.en_US
    hyphenDicts.de_DE

    corefonts
    vista-fonts

    ocrmypdf
    poppler-utils
    qpdf
    simple-scan
    tesseract
  ];
}
