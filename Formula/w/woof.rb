class Woof < Formula
  include Language::Python::Shebang

  desc "Ad-hoc single-file webserver"
  homepage "https://www.home.unix-ag.org/simon/woof.html"
  url "https://github.com/simon-budig/woof/archive/refs/tags/woof-20220202.tar.gz"
  sha256 "cf29214aca196a1778e2f5df1f5cc653da9bee8fc2b19f01439c750c41ae83c1"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, all: "f5dd93c7a711b1b98e9eaf0d892ce187468505064e615cce360ac3c4354e4437"
  end

  depends_on "python@3.12"

  conflicts_with "woof-doom", because: "both install `woof` binaries"

  def install
    rewrite_shebang detected_python_shebang, "woof"
    bin.install "woof"
  end

  test do
    port = free_port
    pid = fork do
      exec bin/"woof", "-s", "-p", port.to_s
    end

    sleep 2

    begin
      read = (bin/"woof").read
      assert_equal read, shell_output("curl localhost:#{port}/woof")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
