{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;

let
  cfg = config.modules.desktop.apps.logseq;
in {
  options.modules.desktop.apps.logseq = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs.unstable; [
      (stdenv.mkDerivation rec {
        pname = "logseq";
        version = "0.5.6";

        src = fetchurl {
          url = "https://github.com/logseq/logseq/releases/download/${version}/logseq-linux-x64-${version}.AppImage";
          sha256 = "aLps/nfBBAUJN9bsuESv5aM4eLZofT3p2UtWhr+9vgw=";
          name = "${pname}-${version}.AppImage";
        };

        appimageContents = appimageTools.extract {
          name = "${pname}-${version}";
          inherit src;
        };

        dontUnpack = true;
        dontConfigure = true;
        dontBuild = true;

        nativeBuildInputs = [ makeWrapper ];

        installPhase = ''
          runHook preInstall

          mkdir -p $out/bin $out/share/${pname} $out/share/applications
          cp -a ${appimageContents}/{locales,resources} $out/share/${pname}
          cp -a ${appimageContents}/Logseq.desktop $out/share/applications/${pname}.desktop

          substituteInPlace $out/share/applications/${pname}.desktop \
            --replace Exec=Logseq Exec=${pname} \
            --replace Icon=Logseq Icon=$out/share/${pname}/resources/app/icons/logseq.png

          runHook postInstall
        '';

        postFixup = ''
          makeWrapper ${electron_15}/bin/electron $out/bin/${pname} \
            --add-flags $out/share/${pname}/resources/app
        '';

        meta = with lib; {
          description = "A local-first, non-linear, outliner notebook for organizing and sharing your personal knowledge base";
          homepage = "https://github.com/logseq/logseq";
          license = licenses.agpl3Plus;
          platforms = [ "x86_64-linux" ];
        };
      })
    ];
  };
}
