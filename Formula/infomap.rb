class Infomap < Formula
  desc "Multi-level network clustering based on the Map Equation"
  homepage "https://github.com/mapequation/infomap"
  url "https://github.com/mapequation/infomap/archive/refs/tags/v2.15.0.tar.gz"
  sha256 "4d3b72852f335495357ab568de4747e4f0bbb4904169d8eeda30c8642859f6c1"
  license "GPL-3.0-or-later"

  option "without-openmp", "Build without OpenMP support"

  on_macos do
    depends_on "libomp"
  end

  def install
    if OS.mac? && build.with?("openmp")
      ENV.append "CPPFLAGS", "-I#{Formula["libomp"].opt_include}"
      ENV.append "CXXFLAGS", "-I#{Formula["libomp"].opt_include}"
      ENV.append "LDFLAGS", "-L#{Formula["libomp"].opt_lib}"
    end

    if (buildpath/"mk/common.mk").exist?
      args = ["build-native", "JOBS=#{ENV.make_jobs}"]
      args << "OPENMP=0" if build.without? "openmp"
    else
      args = ["-j#{ENV.make_jobs}"]
      args.unshift("noomp") if build.without? "openmp"
    end

    system "make", *args

    bin.install "Infomap"
    if Utils.safe_popen_read(bin/"Infomap", "--help").include?("--completion")
      generate_completions_from_executable(bin/"Infomap", "--completion", shells: [:bash, :zsh])
    end
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

    if shell_output("#{bin}/Infomap --help").include?("--completion")
      assert_match "--flow-model", shell_output("#{bin}/Infomap --completion bash")
      assert_match "#compdef Infomap infomap", shell_output("#{bin}/Infomap --completion zsh")
    end
  end
end
