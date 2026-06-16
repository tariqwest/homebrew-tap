class AfmJs < Formula
  desc "Apple Foundation Models for Node.js — OpenAI-compatible HTTP server + CLI"
  homepage "https://github.com/tariqwest/afm-js"
  url "https://github.com/tariqwest/afm-js/releases/download/v0.0.7/afm-js-prebuilt-arm64-apple-darwin-0.0.7.tar.gz"
  sha256 "7a5d93bd65e7308e1d0f6bbf49eaeb268cfc8ad23c658537f0e33b6e485073f6"
  license "MIT"
  version "0.0.7"

  depends_on "node"
  depends_on :macos
  depends_on arch: :arm64

  resource "afm-fm-helper" do
    url "https://github.com/tariqwest/afm-js/releases/download/v0.0.7/afm-fm-helper-arm64-apple-darwin-0.0.7.tar.gz"
    sha256 "79e57417360d22b4696c19174c18647ef20adb37f979d987015a936f865fb4c3"
  end

  def install
    # Install prebuilt afm-js package
    libexec.install Dir["dist"], "bin"

    # Create wrapper script that uses Homebrew's node
    (bin/"afm-js").write <<~EOS
      #!/bin/bash
      export AFM_JS_HELPER_PATH="#{opt_prefix}/libexec/afm-fm-helper"
      exec "#{Formula["node"].opt_bin}/node" "#{libexec}/bin/afm-js.js" "$@"
    EOS
    chmod 0755, bin/"afm-js"

    # Install helper binary from resource
    resource("afm-fm-helper").stage do
      libexec.install "afm-fm-helper"
    end
    chmod 0755, libexec/"afm-fm-helper"
  end

  def caveats
    <<~EOS
      afm-js requires:
        - macOS 26 (Tahoe) or later
        - Apple Silicon (M1+)
        - Apple Intelligence enabled in System Settings

      To start the server manually:
        afm-js serve --port 11434

      To run as a background service (auto-starts at login):
        brew services start afm-js

      Manage the service:
        brew services stop afm-js
        brew services restart afm-js
        brew services info afm-js
    EOS
  end

  service do
    run [opt_bin/"afm-js", "serve"]
    keep_alive true
    log_path var/"log/afm-js.log"
    error_log_path var/"log/afm-js-error.log"
    environment_variables AFM_JS_HELPER_PATH: opt_prefix/"libexec/afm-fm-helper",
                        AFM_JS_PORT: "1337",
                        AFM_JS_TOKEN: "sk-apple-1337"
    require_root false
  end

  def caveats
    <<~EOS
      afm-js requires:
        - macOS 26 (Tahoe) or later
        - Apple Silicon (M1+)
        - Apple Intelligence enabled in System Settings

      To start the server manually:
        afm-js serve --port 1337

      The service runs with default port 1337 and token sk-apple-1337.
      To configure the service with custom port or token:
        brew services set-env afm-js AFM_JS_PORT 8080
        brew services set-env afm-js AFM_JS_TOKEN your-secret-token
        brew services restart afm-js

      To run as a background service (auto-starts at login):
        brew services start afm-js

      Manage the service:
        brew services stop afm-js
        brew services restart afm-js
        brew services info afm-js
    EOS
  end

  test do
    # Test that the binary runs
    assert_match "afm-js", shell_output("#{bin}/afm-js --help")
    
    # Test health endpoint if server can start briefly
    # Note: This may fail if Apple Intelligence is not available
  end
end
