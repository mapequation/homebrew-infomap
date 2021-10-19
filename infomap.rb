class Infomap < Formula
  desc "Multi-level network clustering based on the Map Equation"
  homepage "https://mapequation.org/infomap"
  url "https://github.com/mapequation/infomap/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "76876cde2eb8f4e81591c1f491494fdd2558d5f587133c641f66c859c521959c"
  license "AGPL-3.0-or-later"

  depends_on "libomp" => :recommended

  def install
    if build.with? "libomp"
      system "make", "-j"
    else
      system "make", "-j", "noomp"
    end

    bin.install "Infomap" => "Infomap"
  end

  test do
    system "Infomap", "--version"
  end
end
