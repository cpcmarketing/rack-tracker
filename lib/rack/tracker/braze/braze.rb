class Rack::Tracker::Braze < Rack::Tracker::Handler
  class Event < OpenStruct
    def write
      meta_data = ""
      properties.present?  ? meta_data << properties_to_json : meta_data
    end

    def properties_to_json
      props = properties.to_json
    end
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
