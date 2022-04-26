class Caddy < Formula
  desc "Powerful, enterprise-ready, open source web server with automatic HTTPS"
  homepage "https://caddyserver.com/"
  url "https://github.com/caddyserver/caddy/archive/v2.5.0.tar.gz"
  sha256 "65b050af067dba4ff28d10dede5973a70474e7a7fc89ad8d7bc353f7c022732f"
  license "Apache-2.0"
  head "https://github.com/caddyserver/caddy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e53efacd4bd5640c41166283fbfbaff87b9253924b0826cc575ead49dac47b1c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e53efacd4bd5640c41166283fbfbaff87b9253924b0826cc575ead49dac47b1c"
    sha256 cellar: :any_skip_relocation, monterey:       "bd13b5a98eaa76fe757a8a14b2dfccc76eb93eaa736a98398e8e35d7620cd4a5"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd13b5a98eaa76fe757a8a14b2dfccc76eb93eaa736a98398e8e35d7620cd4a5"
    sha256 cellar: :any_skip_relocation, catalina:       "bd13b5a98eaa76fe757a8a14b2dfccc76eb93eaa736a98398e8e35d7620cd4a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9d44625b45d2476bd1f8c049c30dac3bfc4732e7e00b88f0821d7b351995ace"
  end

  depends_on "go" => :build

  resource "xcaddy" do
    url "https://github.com/caddyserver/xcaddy/archive/v0.3.0.tar.gz"
    sha256 "1a59ff6f51959072a512002e7ec280ea96775361277ba046a8af5a820a37aacd"
  end

  def install
    revision = build.head? ? version.commit : "v#{version}"

    resource("xcaddy").stage do
      system "go", "run", "cmd/xcaddy/main.go", "build", revision, "--output", bin/"caddy"
    end
  end

  service do
    run [opt_bin/"caddy", "run", "--config", etc/"Caddyfile"]
    keep_alive true
    error_log_path var/"log/caddy.log"
    log_path var/"log/caddy.log"
  end

  test do
    port1 = free_port
    port2 = free_port

    (testpath/"Caddyfile").write <<~EOS
      {
        admin 127.0.0.1:#{port1}
      }

      http://127.0.0.1:#{port2} {
        respond "Hello, Caddy!"
      }
    EOS

    fork do
      exec bin/"caddy", "run", "--config", testpath/"Caddyfile"
    end
    sleep 2

    assert_match "\":#{port2}\"",
      shell_output("curl -s http://127.0.0.1:#{port1}/config/apps/http/servers/srv0/listen/0")
    assert_match "Hello, Caddy!", shell_output("curl -s http://127.0.0.1:#{port2}")

    assert_match version.to_s, shell_output("#{bin}/caddy version")
  end
end
