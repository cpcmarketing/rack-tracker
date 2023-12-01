class Rack::Tracker::Hotjar < Rack::Tracker::Handler
  # self.position = :body
  # self.allowed_tracker_options = [:site_id]

  class Event < OpenStruct
  end

  class Identify < Event
    def name
      'identify'
    end
  end
end
