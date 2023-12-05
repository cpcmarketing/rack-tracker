class Rack::Tracker::Cordial < Rack::Tracker::Handler
  self.position = :body
  self.allowed_tracker_options = [:id]

  class Event < OpenStruct
    def write
      meta_data = type_to_json
      options.present? ? meta_data << options_to_json : meta_data
      event_id.present? ? meta_data << event_id_to_json : meta_data
    end

    private

    def type_to_json
      type.to_json
    end

    def event_id_to_json
      ", #{event_id.to_json}"
    end

    def options_to_json
      ", #{options.to_json}"
    end
  end

  class Init < Event
    def name
      'init'
    end
  end

  class Track < Event
    def name
      'track'
    end
  end

  class TrackCustom < Event
    def name
      'trackCustom'
    end
  end
end
