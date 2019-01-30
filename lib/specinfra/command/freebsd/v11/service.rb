class Specinfra::Command::Freebsd::V11::Service < Specinfra::Command::Base::Service
  class << self
    def enable(service)
      "sysrc `service #{escape(service)} rcvar | grep '^#{escape(service)}' | sed 's/\"//g' | sed -E 's/(YES|NO)/YES/'`"
    end

    def disable(service)
      "sysrc `service #{escape(service)} rcvar | grep '^#{escape(service)}' | sed 's/\"//g' | sed -E 's/(YES|NO)/NO/'`"
    end
  end
end
