class Pktide < Formula
  desc "Lightweight packet monitor for legacy and modern Linux and macOS"
  homepage "https://github.com/devwooops/pktide"
  if OS.mac?
    url "https://github.com/devwooops/pktide/releases/download/v0.1.0/pktide-macos",
        using: :nounzip
    sha256 "f7ad27c8407a788ab3c484feaaae3182077bf66d8c1899f11133a2f9f7ea28b4"
  else
    url "https://github.com/devwooops/pktide/releases/download/v0.1.0/pktide-x86_64",
        using: :nounzip
    sha256 "486d9f3e7517ef82a824f1213198818aa6edd257254075e20bb32adfb1aa03e2"
  end
  license "MIT"

  on_linux do
    depends_on arch: :x86_64
  end

  def install
    binary = OS.mac? ? "pktide-macos" : "pktide-x86_64"
    bin.install binary => "pktide"
    (bin/"pktide").chmod 0755
  end

  def caveats
    <<~EOS
      Live capture requires root or OS-specific capture permissions.
      Reading saved PCAP files does not require elevated privileges.

      Example: pktide -r capture.pcap 'tcp port 443'
      Live capture on macOS remains unverified upstream; see the validation record:
        https://github.com/devwooops/pktide/blob/main/docs/VALIDATION.md
    EOS
  end

  test do
    ethernet = ["00112233445566778899aabb0800"].pack("H*")
    tcp = ethernet + ["450000280001000040060000c000020ac6336414" \
                      "303901bb00000001000000005002200000000000"].pack("H*")
    udp = ethernet + ["450000200001000040110000c000020ac6336414" \
                      "30390035000c000074657374"].pack("H*")
    header = [0xa1b2c3d4, 2, 4, 0, 0, 65535, 1].pack("VvvVVVV")
    records = [tcp, udp].map do |packet|
      [1700000000, 123456, packet.bytesize, packet.bytesize].pack("V4") + packet
    end
    (testpath/"mixed.pcap").binwrite(header + records.join)

    output = shell_output("#{bin}/pktide -r mixed.pcap 'tcp port 443'")
    assert_match "192.0.2.10:12345 > 198.51.100.20:443 TCP [S]", output
    refute_match "UDP", output
    assert_match "UDP", shell_output("#{bin}/pktide -r mixed.pcap 'udp port 53'")

    system bin/"pktide", "-r", "mixed.pcap", "-q", "-w", "filtered.pcap", "tcp port 443"
    assert_equal header + records.first, (testpath/"filtered.pcap").binread
    assert_match "TCP [S]", shell_output("#{bin}/pktide -r filtered.pcap")
  end
end
