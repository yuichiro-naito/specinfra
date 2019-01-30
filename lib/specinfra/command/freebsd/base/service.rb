class Specinfra::Command::Freebsd::Base::Service < Specinfra::Command::Base::Service
  class << self
    def check_is_enabled(service, level=3)
      "service #{escape(service)} enabled"
    end

    def check_is_running(service)
      "service #{escape(service)} status | grep -E 'as (pid [0-9]+)'"
    end

    def enable(service)
      "service #{escape(service)} enable"
    end

    def disable(service)
      "service #{escape(service)} disable"
    end
  end
end
