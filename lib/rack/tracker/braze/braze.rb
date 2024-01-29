class Rack::Tracker::Braze < Rack::Tracker::Handler
  class Event < OpenStruct
    def write; end
  end

  class AutomaticallyShowInAppMessages < Event
    def name
      'automaticallyShowInAppMessages'
    end
  end

  class ChangeUser < Event
    def name
      'changeUser'
    end

    def write
      user_id.to_json
    end
  end

  class LogCustomEvent < Event
    def name
      'logCustomEvent'
    end

    def write
      event_name.to_json << ", #{properties.to_json}"
    end
  end

  class OpenSession < Event
    def name
      'openSession'
    end
  end
end
