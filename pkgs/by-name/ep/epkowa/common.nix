lib: {
  homepage = "http://download.ebz.epson.net/dsc/search/01/search/?OSC=LX";
  sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  license = with lib.licenses; epson;
  platforms = with lib.platforms; linux;
}
