class Rack::Tracker::Heap < Rack::Tracker::Handler
  class Event < OpenStruct
    def write
      return if !properties.present?
      properties.to_h
    end
  end

  class Identify < Event
    def name
      'identify'
    end

    def write
      "#{id.to_s}"
    end
  end

  class AddUser < Event
    def name
      'addUserProperties'
    end
  end

  class AddEvent < Event
    def name
      'addEventProperties'
    end
  end
end
