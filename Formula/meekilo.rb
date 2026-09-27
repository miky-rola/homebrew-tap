class Meekilo < Formula
  desc "AI-controlled digital presence for video calls (build-from-source)"
  homepage "https://github.com/miky-rola/meekilo"
  license "MIT"
  head "https://github.com/miky-rola/meekilo.git", branch: "main"

  depends_on "cbindgen" => :build
  depends_on "rust" => :build
  depends_on xcode: ["16.0", :build]
  depends_on "xcodegen" => :build
  depends_on arch: :arm64
  depends_on :macos

  def install
    system "xcodegen", "generate"
    xcodebuild "-project", "Meekilo.xcodeproj", "-target", "Meekilo",
               "-configuration", "Release", "CODE_SIGNING_ALLOWED=NO",
               "SYMROOT=build", "OBJROOT=build", "build"

    app = buildpath/"build/Release/Meekilo.app"
    ext = app/"Contents/Library/SystemExtensions/CameraExtension.systemextension"

    cp "Meekilo/Meekilo.entitlements", "app.entitlements"
    cp "CameraExtension/CameraExtension.entitlements", "ext.entitlements"
    inreplace ["app.entitlements", "ext.entitlements"], "$(TeamIdentifierPrefix)", "", audit_result: false
    system "/usr/libexec/PlistBuddy", "-c", "Delete :com.apple.developer.system-extension.install", "app.entitlements"
    system "plutil", "-replace", "CMIOExtension.CMIOExtensionMachServiceName",
           "-string", "com.sharpetwo.meekilo.cmio", ext/"Contents/Info.plist"
    system "codesign", "--force", "--sign", "-", "--entitlements", "ext.entitlements", ext
    system "codesign", "--force", "--sign", "-", "--entitlements", "app.entitlements", app

    prefix.install app
    (bin/"meekilo-setup").write setup_script
    chmod 0755, bin/"meekilo-setup"
  end

  def setup_script
    <<~EOS
      #!/bin/bash
      set -euo pipefail
      rm -rf /Applications/Meekilo.app
      cp -R "#{opt_prefix}/Meekilo.app" /Applications/
      open /Applications/Meekilo.app
      echo "meekilo is in your menu bar. To use it in Meet/Zoom/Teams:"
      echo "  1. brew install --cask obs   (free, its virtual camera is signed)"
      echo "  2. meekilo menu -> Start AI Camera (opens the preview window)"
      echo "  3. OBS: Sources -> + -> macOS Screen Capture -> Window -> 'meekilo AI Camera'"
      echo "  4. OBS: Start Virtual Camera, then pick 'OBS Virtual Camera' in your call app"
    EOS
  end

  def caveats
    <<~EOS
      No Apple Developer account or SIP changes needed. Finish with:
        meekilo-setup
      Calls receive meekilo through OBS Virtual Camera (see meekilo-setup output).
    EOS
  end

  test do
    assert_path_exists prefix/"Meekilo.app/Contents/MacOS/Meekilo"
  end
end
