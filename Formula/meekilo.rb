class Meekilo < Formula
  desc "AI-controlled virtual camera for macOS (build-from-source, ad-hoc signed)"
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
      if csrutil status | grep -q enabled; then
          echo "SIP is enabled - the ad-hoc signed camera extension cannot load." >&2
          echo "Boot to Recovery (hold power), open Terminal, run: csrutil disable" >&2
          exit 1
      fi
      if ! systemextensionsctl developer 2>/dev/null | grep -q on; then
          echo "Enabling system extension developer mode (password prompt)..."
          sudo systemextensionsctl developer on
      fi
      sudo rm -rf /Applications/Meekilo.app
      sudo cp -R "#{opt_prefix}/Meekilo.app" /Applications/
      open /Applications/Meekilo.app
      echo "Click 'Install AI Camera' in the menu bar, then approve in System Settings."
    EOS
  end

  def caveats
    <<~EOS
      This build is ad-hoc signed (no Apple Developer account), so macOS loads
      the camera extension only with SIP disabled and system-extension developer
      mode on. Finish the install with:
        meekilo-setup
    EOS
  end

  test do
    assert_path_exists prefix/"Meekilo.app/Contents/MacOS/Meekilo"
  end
end
