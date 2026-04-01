class SystemMonitor < Formula
  desc "Lightweight cross-platform system monitoring tool with desktop notifications"
  homepage "https://github.com/miky-rola/system-monitor"
  version "0.3.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/miky-rola/system-monitor/releases/download/v0.3.1/system-monitor-macos-aarch64.tar.gz"
      sha256 "3d2b4fea8e8ffcf1a121c9723ebdd26d7be319b160f8b7053be03f1fa0db8ca9"
    else
      url "https://github.com/miky-rola/system-monitor/releases/download/v0.3.1/system-monitor-macos-x86_64.tar.gz"
      sha256 "e82874b290bc9279cf026ddbd8666ca3c09062a330983faa6acd6b2dd7ce45dd"
    end
  end

  on_linux do
    url "https://github.com/miky-rola/system-monitor/releases/download/v0.3.1/system-monitor-linux-x86_64.tar.gz"
    sha256 "58e5acc1ceec9cef6e1c6afce079270c7e4b1f2fa8c1a596994537da1acbe58b"
  end

  def install
    matched = Dir.glob("system-monitor*").first
    bin.install matched => "system-monitor"
  end

  service do
    run [opt_bin/"system-monitor", "daemon"]
    keep_alive true
    log_path var/"log/system-monitor.log"
    error_log_path var/"log/system-monitor.log"
  end

  test do
    assert_match "system-monitor", shell_output("#{bin}/system-monitor --version")
  end
end
