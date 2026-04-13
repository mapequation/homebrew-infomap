class Infomap < Formula
  desc "Multi-level network clustering based on the Map Equation"
  homepage "https://github.com/mapequation/infomap"
  url "https://github.com/mapequation/infomap/archive/refs/tags/v2.9.2.tar.gz"
  sha256 "2a94f10dd3974ebb2b5ffabae5c018b928e10926cb9b3d9ba77f5416e0a7c392"
  license "GPL-3.0-or-later"

  option "without-openmp", "Build without OpenMP support"

  on_macos do
    depends_on "libomp" if build.with? "openmp"
  end

  def install
    if OS.mac? && build.with?("openmp")
      ENV.append "CPPFLAGS", "-I#{Formula["libomp"].opt_include}"
      ENV.append "CXXFLAGS", "-I#{Formula["libomp"].opt_include}"
      ENV.append "LDFLAGS", "-L#{Formula["libomp"].opt_lib}"
    end

    if (buildpath/"mk/common.mk").exist?
      args = ["build-native", "JOBS=#{ENV.make_jobs}"]
      args << "OPENMP=0" unless build.with? "openmp"
      system "make", *args
    else
      args = ["-j#{ENV.make_jobs}"]
      args.unshift("noomp") unless build.with? "openmp"
      system "make", *args
    end

    bin.install "Infomap"
  end

  def caveats
    <<~EOS
      This formula installs the native Infomap CLI.

      Run it with:
        Infomap --help
        Infomap --version

      For the Python package/API, use:
        pip install infomap
    EOS
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
