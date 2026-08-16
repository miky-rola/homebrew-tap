class SystemMonitor < Formula
  desc "Lightweight cross-platform system monitoring tool with desktop notifications"
  homepage "https://github.com/miky-rola/system-monitor"
  version "0.4.2"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/miky-rola/system-monitor/releases/download/v0.4.2/system-monitor-macos-aarch64.tar.gz"
      sha256 "ea85e6df8af33a89abb122a92afb6564ee934fb9aa78904f6f070428e2e99042"
    end

    on_intel do
      url "https://github.com/miky-rola/system-monitor/releases/download/v0.4.2/system-monitor-macos-x86_64.tar.gz"
      sha256 "3bff29fc5c4b532b225662faa8229e5bf364c48b6ed4b74d4f928989486deec9"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/miky-rola/system-monitor/releases/download/v0.4.2/system-monitor-linux-x86_64.tar.gz"
      sha256 "c4c0dec93b47c9fab4e02f2346cabc8dcca8ebaffc41761b62899f74de36b2f7"
    end
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
