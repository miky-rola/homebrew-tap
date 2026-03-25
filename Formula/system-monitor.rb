class SystemMonitor < Formula
  desc "Lightweight cross-platform system monitoring tool with desktop notifications"
  homepage "https://github.com/miky-rola/system-monitor"
  version "0.2.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/miky-rola/system-monitor/releases/download/v0.2.0/system-monitor-macos-aarch64.tar.gz"
      sha256 "da1acf871d7998ae85942c6f227b9c877127aa18376311ee0fd200902c097f95"
    else
      url "https://github.com/miky-rola/system-monitor/releases/download/v0.2.0/system-monitor-macos-x86_64.tar.gz"
      sha256 "876cfbf1c1c9069bcd43976fdb618e3b3b9fbd4921a985e7e8a616308e54a789"
    end
  end

  on_linux do
    url "https://github.com/miky-rola/system-monitor/releases/download/v0.2.0/system-monitor-linux-x86_64.tar.gz"
    sha256 "36ae9b8729c140b2ba5632b6f43bcf176d598035335196c54f4176b36e0ea075"
  end

  def install
    bin.install "system-monitor"
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
