require 'time'

module GPX
  class Segment
    attr_reader :doc, :pause_length

    def initialize(file, pause_length: 5)
      @doc = File.open(file) { |f| Nokogiri::XML(f) }
      @pause_length = pause_length
    end

    def rewrite
      doc.css('trk').find_all.each do |trk|
        segments = extract_segments(trk)

        trk.css('trkseg').find_all.each(&:remove)

        segments.each do |points|
          next if points.empty?

          trkseg = trk.add_child('<trkseg />').first

          points.each do |point|
            trkseg.add_child(point)
          end
        end
      end

      true
    end

    def write(out)
      File.write(out, to_s)
    end

    def to_s
      doc.to_s
    end

    private

    def extract_segments(node)
      trkpts = node.css('trkpt')

      trkpts.each_cons(2).with_object([[]]) do |(a, b), memo|
        memo.last << a
        memo << [] if time(b) - time(a) > pause_length
        memo.last << b
      end
    end

    def time(node)
      Time.parse(node.css('time').text)
    end
  end
end
