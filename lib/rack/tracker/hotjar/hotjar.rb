class Rack::Tracker::Hotjar < Rack::Tracker::Handler
  class Event < OpenStruct
  end

  class Identify < Event
    def name
      'identify'
    end
  end
end
