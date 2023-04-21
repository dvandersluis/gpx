# frozen_string_literal: true

RSpec.describe GPX::Splitter do
  subject(:doc) { splitter.doc }

  let(:splitter) { described_class.new("spec/files/#{file}.gpx", pause_length: pause_length) }
  let(:pause_length) { 5 }
  let(:expected) do
    File.open("spec/files/#{file}_split.gpx") { |f| Nokogiri::XML(f) }
  end

  describe '#split' do
    context 'with a simple file' do
      let(:file) { 'simple' }

      it 'splits track points into segments' do
        splitter.split
        expect(doc).to be_equivalent_to(expected)
      end
    end

    context 'with multiple <trkseg>s' do
      let(:file) { 'multiple_trksegs' }

      it 'splits track points into segments' do
        splitter.split
        expect(doc).to be_equivalent_to(expected)
      end
    end

    context 'with multiple <trk>s' do
      let(:file) { 'multiple_tracks' }

      it 'splits track points into segments' do
        splitter.split
        expect(doc).to be_equivalent_to(expected)
      end
    end
  end
end
