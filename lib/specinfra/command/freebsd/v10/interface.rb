class Specinfra::Command::Freebsd::V10::Interface < Specinfra::Command::Freebsd::Base::Interface
  class << self
    def get_ipv4_address(interface)
      "ifconfig #{interface} inet | grep inet | awk '{print $2}'"
    end

    def get_ipv6_address(interface)
      # Awk refuses to print '/' even with using escapes or hex so workaround with sed employed here.
      "ifconfig #{interface} inet6 | grep inet6 | awk '{print $2$3$4}' | sed 's/prefixlen/\//'; exit"
    end
  end
end
