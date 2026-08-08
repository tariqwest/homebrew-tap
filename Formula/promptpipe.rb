class Promptpipe < Formula
  desc "Unix-style prompt and stdin piping for AI coding CLIs"
  homepage "https://github.com/tariqwest/promptpipe"
  url "https://github.com/tariqwest/promptpipe/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "56863e315adadac76d44d2844d1ab7aeef75adda71094bdccfff451325e3972f"
  license "MIT"

  depends_on "bun"

  def install
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/promptpipe"
    bin.write_exec_script libexec/"bin/pp"
    bin.write_exec_script libexec/"bin/ppipe"
  end

  test do
    system bin/"promptpipe", "--help"
  end
end
