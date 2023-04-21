RSpec.describe GPX::Segment do
  let(:pause_length) { 5 }
  let(:expected) do
    File.open("spec/files/#{file}_expected.gpx") { |f| Nokogiri::XML(f) }
  end

  subject { described_class.new("spec/files/#{file}.gpx", pause_length: pause_length) }

  describe '#split' do
    context 'for a simple file' do
      let(:file) { 'simple' }

      it 'splits track points into segments' do
        subject.split
        expect(subject.doc).to be_equivalent_to(expected)
      end
    end

    context 'with multiple <trkseg>s' do
      let(:file) { 'multiple_trksegs' }

      it 'splits track points into segments' do
        subject.split
        expect(subject.doc).to be_equivalent_to(expected)
      end
    end

    context 'with multiple <trk>s' do
      let(:file) { 'multiple_tracks' }

      it 'splits track points into segments' do
        subject.split
        expect(subject.doc).to be_equivalent_to(expected)
      end
    end
  end
end
