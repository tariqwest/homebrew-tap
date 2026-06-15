class ApfelPlus < Formula
  desc "On-device Apple FoundationModels CLI and OpenAI-compatible server"
  homepage "https://github.com/tariqwest/apfel-plus"
  url "https://github.com/tariqwest/apfel-plus.git",
      tag:      "v1.6.0",
      revision: "c514d60a78cebd57594216537fb3aa06f0afe52c"
  license "MIT"
  head "https://github.com/tariqwest/apfel-plus.git", branch: "main"

  on_macos do
    depends_on macos: :tahoe
  end
  depends_on xcode: ["26.0", :build]

  def install
    # Build release binary
    system "swift", "build",
           "-c", "release",
           "--disable-sandbox",
           "--scratch-path", buildpath/".build"

    bin.install buildpath/".build/release/apfel-plus"

    # Install man page (substitute version placeholder)
    inreplace "man/apfel-plus.1.in", "%%VERSION%%", version.to_s
    man1.install "man/apfel-plus.1.in" => "apfel-plus.1"

    # Install demo scripts as apfel-plus-<name> companion commands
    pkgshare.install "demo"
    %w[cmd explain gitsum mac-narrator naming oneliner port wtd].each do |d|
      target = pkgshare/"demo/#{d}"
      next unless target.exist?

      bin.install_symlink target => "apfel-plus-#{d}"
    end
  end

  service do
    run [opt_bin/"apfel-plus", "--serve"]
    keep_alive true
    log_path var/"log/apfel-plus.log"
    error_log_path var/"log/apfel-plus.log"
  end

  def caveats
    <<~EOS
      apfel-plus requires:
        - macOS 26 Tahoe or newer
        - Apple Silicon (M1 or later)
        - Apple Intelligence enabled in System Settings > Apple Intelligence & Siri

      Verify everything is ready:
        apfel-plus --model-info

      If the model is unavailable, enable Apple Intelligence:
        https://support.apple.com/en-us/121115

      Start the OpenAI-compatible server:
        apfel-plus --serve

      Or as a background service:
        brew services start apfel-plus

      Companion demo commands (pipe-friendly bash scripts):
        apfel-plus-cmd           natural language -> shell command
        apfel-plus-oneliner      complex awk/sed/find pipe chains
        apfel-plus-explain       explain a command, error, or code snippet
        apfel-plus-wtd           "what's this directory?" project orientation
        apfel-plus-naming        suggest names for functions/variables/classes
        apfel-plus-port          identify the process on a port
        apfel-plus-gitsum        plain-English summary of recent git activity
        apfel-plus-mac-narrator  dry-British-humor system narration
    EOS
  end

  test do
    assert_match "apfel-plus v#{version}", shell_output("#{bin}/apfel-plus --version")
    assert_path_exists man1/"apfel-plus.1"
    assert_path_exists bin/"apfel-plus-cmd"
    assert_predicate bin/"apfel-plus-cmd", :symlink?
  end
end
