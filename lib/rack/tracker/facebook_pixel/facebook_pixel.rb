class Rack::Tracker::FacebookPixel < Rack::Tracker::Handler
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

    def write
      options.present? ? options_to_json : nil
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

  def inject(response)
    # Sub! is enough, in well formed html there's only one head or body tag.
    # Block syntax need to be used, otherwise backslashes in input will mess the output.
    # @see http://stackoverflow.com/a/4149087/518204 and https://github.com/railslove/rack-tracker/issues/50
    response.sub! %r{<head.*?>} do |m|
      m.to_s << self.render_head
    end
    response.sub! %r{<body.*?>} do |m|
      m.to_s << self.render_body
    end
    response
  end

  def render_head
    Tilt.new( File.join( File.dirname(__FILE__), 'template', 'facebook_pixel_head.erb') ).render(self)
  end

  def render_body
    Tilt.new( File.join( File.dirname(__FILE__), 'template', 'facebook_pixel_body.erb') ).render(self)
  end
end
