class Specinfra::Command::Freebsd::Base::Interface < Specinfra::Command::Base::Interface
  class << self
    def check_exists(name)
      "ifconfig #{name}"
    end

    def get_speed_of(name)
      "ifconfig #{name} | awk '/media:/{if(match($0,/[0-9]+/)){ print substr($0, RSTART, RLENGTH);}}'"
    end

    def get_mtu_of(name)
      "ifconfig #{name} | awk '/mtu /{print $NF}'"
    end

    def check_has_ipv4_address(interface, ip_address)
      ip_address = ip_address.dup
      if ip_address =~ /\/\d+$/
        # remove the prefix - better would be to calculate the netmask
        ip_address.gsub!(/\/\d+$/, "")
      end
      ip_address << " "
      ip_address.gsub!(".", "\\.")
      "ifconfig #{interface} inet | grep 'inet #{ip_address}'"
    end

    def check_has_ipv6_address(interface, ip_address)
      ip_address = ip_address.dup
      (ip_address, prefixlen) = ip_address.split(/\//)
      ip_address.downcase!
      if ip_address =~ /^fe80::/i
        # link local needs the scope (interface) appended
        ip_address << "%#{interface}"
      end
      unless prefixlen.to_s.empty?
        # append prefixlen
        ip_address << " prefixlen #{prefixlen}"
      else
        ip_address << " "
      end
      "ifconfig #{interface} inet6 | grep 'inet6 #{ip_address}'"
    end

    def get_ipv4_address(interface)
      "ifconfig -f inet:cidr #{interface} inet | awk '/inet /{print $2}'"
    end

    def get_ipv6_address(interface)
      "ifconfig -f inet6:cidr #{interface} inet6 | awk '/inet6 /{print $2}' | tail -1"
    end

    def get_link_state(interface)
      # Checks if interfaces is administratively up with the -u arg.
      # L1 check via status. Virtual interfaces like tapX missing the status will report up.
      # Emulates operstate in linux with exception of the unknown status.
      %Q{ifconfig -u #{interface} 2>&1 | awk -v s=up '/status:/ && $2 != "active" { s="down" }; END {print s}'}
    end
  end
end
