class AfmJs < Formula
  desc "Apple Foundation Models for Node.js — OpenAI-compatible HTTP server + CLI"
  homepage "https://github.com/tariqwest/afm-js"
  url "https://github.com/tariqwest/afm-js/releases/download/v0.0.8/afm-js-prebuilt-arm64-apple-darwin-0.0.8.tar.gz"
  sha256 "c9489c42e3b5061234061dc87fdcb8dafb2794a27091d6eb06371f3e2d2d8c00"
  license "MIT"
  version "0.0.8"

  depends_on "node"
  on_macos do
    depends_on arch: :arm64
  end

  resource "afm-fm-helper" do
    url "https://github.com/tariqwest/afm-js/releases/download/v0.0.8/afm-fm-helper-arm64-apple-darwin-0.0.8.tar.gz"
    sha256 "3d7915a2dc81f094d5e12529c12fdf25f7052b4e67a9070642208c68ad5a0174"
  end

  def install
    # Install prebuilt afm-js package (dist, bin, and bundled node_modules)
    libexec.install "dist", "bin", "node_modules"

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

  service do
    run [opt_bin/"afm-js", "serve"]
    keep_alive true
    log_path var/"log/afm-js.log"
    error_log_path var/"log/afm-js-error.log"
    environment_variables AFM_JS_HELPER_PATH: opt_prefix/"libexec/afm-fm-helper",
                          AFM_JS_PORT: "1337",
                          AFM_JS_TOKEN: "*************"
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

      The service runs with default port 1337 and token *************.
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
