RSpec.describe Rack::Tracker::FacebookPixel do
  def env
    { 'PIXEL_ID' => 'DYNAMIC_PIXEL_ID' }
  end

  describe 'with static id' do
    subject { described_class.new(env, id: 'PIXEL_ID').render_head }

    it 'will push the tracking events to the queue' do
      expect(subject).to match(%r{fbq\('init', 'PIXEL_ID'\)})
    end

    it 'will add the noscript fallback' do
      expect(subject).to match(%r{https://www.facebook.com/tr\?id=PIXEL_ID&ev=PageView&noscript=1})
    end
  end

  describe 'with dynamic id' do
    subject { described_class.new(env, id: lambda { |env| env['PIXEL_ID'] }).render_head }

    it 'will push the tracking events to the queue' do
      expect(subject).to match(%r{fbq\('init', 'DYNAMIC_PIXEL_ID'\)})
    end

    it 'will add the noscript fallback' do
      expect(subject).to match(%r{https://www.facebook.com/tr\?id=DYNAMIC_PIXEL_ID&ev=PageView&noscript=1})
    end
  end

  describe 'with events' do
    def env
      {
        'tracker' => {
        'facebook_pixel' =>
          [
            {
              'type' => 'Purchase',
              'class_name' => 'Track',
              'options' =>
                {
                  'value' => '23',
                  'currency' => 'EUR'
                }
            },{
              'type' => 'FrequentShopper',
              'class_name' => 'TrackCustom',
              'options' =>
                {
                  'purchases' => 8,
                  'category' => 'Sport'
                }
            }
          ]
        }
      }
    end
    subject { described_class.new(env).render_head }

    it 'will push the tracking events to the queue' do
      expect(subject).to match(%r{"track", "Purchase", \{"value":"23","currency":"EUR"\}})
      expect(subject).to match(%r{"trackCustom", "FrequentShopper", \{"purchases":8,"category":"Sport"\}})
    end

    it 'will add the noscript fallback' do
      expect(subject).to match(%r{https://www.facebook.com/tr\?id=&ev=PageView&noscript=1})
    end
  end

  describe '#inject' do
    subject { handler_object.inject(example_response) }
    let(:handler_object) { described_class.new(env, container: 'somebody') }

    before do
      allow(handler_object).to receive(:render_head).and_return('<script>"HEAD"</script>')
      allow(handler_object).to receive(:render_body).and_return('<script>"BODY"</script>')
    end

    context 'with one line html response' do
      let(:example_response) { "<html><head></head><body></body></html>" }

      it 'will have render_head content in head tag' do
        expect(subject).to match(%r{<head>.*<script>"HEAD"</script>.*</head>})
      end

      it 'will have render_body content in body tag' do
        expect(subject).to match(%r{<body>.*<script>"BODY"</script>.*</body>})
      end

    end
  end
end
