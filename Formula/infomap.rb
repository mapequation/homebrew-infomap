class Infomap < Formula
  desc "Multi-level network clustering based on the Map Equation"
  homepage "https://github.com/mapequation/infomap"
  url "https://github.com/mapequation/infomap/archive/refs/tags/v2.9.2.tar.gz"
  sha256 "2a94f10dd3974ebb2b5ffabae5c018b928e10926cb9b3d9ba77f5416e0a7c392"
  license "GPL-3.0-or-later"

  on_macos do
    depends_on "libomp"
  end

  def install
    if OS.mac?
      ENV.append "CPPFLAGS", "-I#{Formula["libomp"].opt_include}"
      ENV.append "CXXFLAGS", "-I#{Formula["libomp"].opt_include}"
      ENV.append "LDFLAGS", "-L#{Formula["libomp"].opt_lib}"
    end

    if (buildpath/"mk/common.mk").exist?
      system "make", "build-native", "JOBS=#{ENV.make_jobs}"
    else
      system "make", "-j#{ENV.make_jobs}"
    end

    bin.install "Infomap"
  end

  test do
    (testpath/"tiny.net").write <<~EOS
      1 2
      2 3
      3 1
    EOS

    output_dir = testpath/"output"
    output_dir.mkpath
    system bin/"Infomap", testpath/"tiny.net", output_dir, "--tree", "--silent"

    assert_match version.to_s, shell_output("#{bin}/Infomap --version")
    assert_path_exists output_dir/"tiny.tree"
  end
end
