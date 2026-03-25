class SystemMonitor < Formula
  desc "Lightweight cross-platform system monitoring tool with desktop notifications"
  homepage "https://github.com/miky-rola/system-monitor"
  version "0.3.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/miky-rola/system-monitor/releases/download/v0.3.0/system-monitor-macos-aarch64.tar.gz"
      sha256 "f6a40e51261a10d0137183d591201ebb0311a5749f3fb9fbae617b67dc50fdfe"
    else
      url "https://github.com/miky-rola/system-monitor/releases/download/v0.3.0/system-monitor-macos-x86_64.tar.gz"
      sha256 "011f35bc1104c4e97670d21170fe6c1d3e930acf379249373c34f48c84d05af9"
    end
  end

  on_linux do
    url "https://github.com/miky-rola/system-monitor/releases/download/v0.3.0/system-monitor-linux-x86_64.tar.gz"
    sha256 "9d58016ed13c445ac9f6e00e26daf0b5ca673e350b748c6ea9760e86f7218099"
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
