{
  pkgs,
  ...
}:

let
  # Shown in System Settings → General → Login Items via AssociatedBundleIdentifiers.
  bundleId = "com.liempo.workstation";
  displayName = "Workstation";

  workstationApp = pkgs.stdenvNoCC.mkDerivation {
    pname = "Workstation";
    version = "1.0";
    dontUnpack = true;
    buildCommand = ''
      mkdir -p "$out/Applications/Workstation.app/Contents/MacOS"
      cat > "$out/Applications/Workstation.app/Contents/Info.plist" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleExecutable</key>
  <string>Workstation</string>
  <key>CFBundleIdentifier</key>
  <string>${bundleId}</string>
  <key>CFBundleName</key>
  <string>${displayName}</string>
  <key>CFBundleDisplayName</key>
  <string>${displayName}</string>
  <key>CFBundlePackageType</key>
  <string>APPL</string>
  <key>CFBundleShortVersionString</key>
  <string>1.0</string>
  <key>CFBundleVersion</key>
  <string>1</string>
  <key>LSUIElement</key>
  <true/>
</dict>
</plist>
EOF
      cat > "$out/Applications/Workstation.app/Contents/MacOS/Workstation" <<'EXE'
#!/bin/sh
# Stub app so launchd jobs can show as "Workstation" in System Settings.
exit 0
EXE
      chmod +x "$out/Applications/Workstation.app/Contents/MacOS/Workstation"
    '';
  };
in
{
  _module.args = {
    workstationBundleId = bundleId;
  };

  # Install under ~/Applications so Launch Services can resolve the bundle id.
  home.file."Applications/Workstation.app" = {
    source = "${workstationApp}/Applications/Workstation.app";
    recursive = true;
  };
}
