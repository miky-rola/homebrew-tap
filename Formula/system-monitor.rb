class SystemMonitor < Formula
  desc "Lightweight cross-platform system monitoring tool with desktop notifications"
  homepage "https://github.com/miky-rola/system-monitor"
  version "0.4.1"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/miky-rola/system-monitor/releases/download/v0.4.1/system-monitor-macos-aarch64.tar.gz"
      sha256 "3f3c79308dd49a7c06191aed97c7ba6fbe5d38be960059c45b4f0257db8885d1"
    else
      url "https://github.com/miky-rola/system-monitor/releases/download/v0.4.1/system-monitor-macos-x86_64.tar.gz"
      sha256 "0c5d988a3dc65061d928f388bcc60a80cea7c5f33cc5e6375756d4b7aa8ee77a"
    end
  end

  on_linux do
    url "https://github.com/miky-rola/system-monitor/releases/download/v0.4.1/system-monitor-linux-x86_64.tar.gz"
    sha256 "1980413757aa9cdba016faf009314124e9f80e66142b89cf53ff6f5b7d4f6d25"
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
