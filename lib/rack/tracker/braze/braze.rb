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
      "#{user_external_id.to_json}"
    end
  end

  class OpenSession < Event
    def name
      'openSession'
    end
  end
end
