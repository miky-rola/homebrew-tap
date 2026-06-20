class SystemMonitor < Formula
  desc "Lightweight cross-platform system monitoring tool with desktop notifications"
  homepage "https://github.com/miky-rola/system-monitor"
  version "0.4.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/miky-rola/system-monitor/releases/download/v0.4.0/system-monitor-macos-aarch64.tar.gz"
      sha256 "e941c7be2a7e53421305ed2cd209135e9c45963a80787c3b5dab4cb618f2950d"
    else
      url "https://github.com/miky-rola/system-monitor/releases/download/v0.4.0/system-monitor-macos-x86_64.tar.gz"
      sha256 "438ac92557addc493f6eb47a00a4943e56db61820cf0d5da16b35990f26aa0e9"
    end
  end

  on_linux do
    url "https://github.com/miky-rola/system-monitor/releases/download/v0.4.0/system-monitor-linux-x86_64.tar.gz"
    sha256 "8228bcbbebe51bad89bbe93737962aec62a647d3a805185d88d9d814a85b96cb"
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
