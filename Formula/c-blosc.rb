class CBlosc < Formula
  desc "Blocking, shuffling and loss-less compression library"
  homepage "https://www.blosc.org/"
  url "https://github.com/Blosc/c-blosc/archive/v1.21.2.tar.gz"
  sha256 "e5b4ddb4403cbbad7aab6e9ff55762ef298729c8a793c6147160c771959ea2aa"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "56aa3cc6d9489e570901292f7a318450c8f05c53de5bdffe72788c47d6870167"
    sha256 cellar: :any,                 arm64_monterey: "7baccb768cf8ab1252769c5a88fb40d3a4833fb3b110cdbb9e549b5b699f3332"
    sha256 cellar: :any,                 arm64_big_sur:  "1330f5de4f7c9529effbadf7798b73346847d629bf24c8bf90887ed3a6419ab9"
    sha256 cellar: :any,                 ventura:        "716720ba2d71c7f6a1e42e4afc4f159ae168d9e1e532324ee904b3d35f934b42"
    sha256 cellar: :any,                 monterey:       "7c982a5118aaffc9565a404da9823789111a3eca0300a20aece2101d29626f56"
    sha256 cellar: :any,                 big_sur:        "e7ef0adf43ef181d7645dfd7f6ab74b5c11c07c0b4cebd473a1096bce406b6ac"
    sha256 cellar: :any,                 catalina:       "feaf08d27a7f27259382d7a67d852b402255e3997daee3dfac0829bd1fc47fd0"
    sha256 cellar: :any,                 mojave:         "e036c972febeb96fbd84b4d40578e5e49c058e43e789946690d8547bb7358c05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19485dcc865d0130c121f9724114d8a320c0724328b5bbf49f4458998f0f860d"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <blosc.h>
      int main() {
        blosc_init();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lblosc", "-o", "test"
    system "./test"
  end
end
