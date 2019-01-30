class Specinfra::Command::Freebsd::V9::Service < Specinfra::Command::Freebsd::V10::Service
  class << self
    def check_is_enabled(service, level=3)
      "service -e | grep -- /#{escape(service)}$"
    end
  end
end
