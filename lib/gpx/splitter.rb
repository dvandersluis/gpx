require 'time'

module GPX
  class Splitter
    # Look for pauses in a GPX file and wrap them in <trkseg> tags.

    attr_reader :filename, :doc, :pause_length

    def initialize(file, pause_length: 5)
      @filename = file
      @doc = File.open(@filename) { |f| Nokogiri::XML(f) }
      @pause_length = pause_length
    end

    def split
      doc.css('trk').each do |trk|
        trk.css('trkseg').each do |trkseg|
          extract_segments(trkseg).each do |points|
            next if points.empty?

            new_node = trkseg.add_previous_sibling('<trkseg />').first

            points.each do |point|
              new_node.add_child(point)
            end
          end

          trkseg.remove
        end
      end

      true
    end

    def write(out = default_out_name)
      File.write(out, to_s)
      out
    end

    def to_s
      doc.to_s
    end

    private

    def extract_segments(node)
      trkpts = node.css('trkpt')
      return [trkpts] if trkpts.one?

      trkpts.each_cons(2).with_object([[]]) do |(a, b), memo|
        memo.last << a
        memo << [] if time(b) - time(a) > pause_length
        memo.last << b
      end
    end

    def time(node)
      Time.parse(node.css('time').text)
    end

    def default_out_name
      filename_without_ext = File.join(File.dirname(filename), File.basename(filename, '.gpx'))
      "#{filename_without_ext}_split_#{Time.now.to_i}.gpx"
    end
  end
end
