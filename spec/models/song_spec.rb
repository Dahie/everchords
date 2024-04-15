# frozen_string_literal: true

require 'spec_helper'

describe Song do
  subject(:song) { build(:song) }

  describe 'validations' do
    specify { expect(build(:song)).to be_valid }

    specify { expect(build(:song, title: '')).not_to be_valid }
    specify { expect(build(:song, title: nil)).not_to be_valid }

    specify { expect(build(:song, notebook: nil)).not_to be_valid }

    specify { expect(build(:song, body: '')).not_to be_valid }
    specify { expect(build(:song, body: nil)).not_to be_valid }
  end

  describe '#may_publish?' do
    subject(:song) { build(:song, state:) }

    %w[draft unpublished].each do |state|
      context "with song in #{state}" do
        let(:state) { state }

        specify { expect(song).to be_may_publish }
      end
    end

    %w[restricted published].each do |state|
      context "with song in #{state}" do
        let(:state) { state }

        specify { expect(song).not_to be_may_publish }
      end
    end
  end

  describe '#may_restrict?' do
    subject(:song) { build(:song, state:) }

    %w[published unpublished].each do |state|
      context "with song in #{state}" do
        let(:state) { state }

        specify { expect(song).to be_may_restrict }
      end
    end

    %w[draft restricted].each do |state|
      context "with song in #{state}" do
        let(:state) { state }

        specify { expect(song).not_to be_may_restrict }
      end
    end
  end

  describe '#may_unpublish?' do
    subject(:song) { build(:song, state:) }

    ['published'].each do |state|
      context "with song in #{state}" do
        let(:state) { state }

        specify { expect(song).to be_may_unpublish }
      end
    end

    %w[draft restricted unpublished].each do |state|
      context "with song in #{state}" do
        let(:state) { state }

        specify { expect(song).not_to be_may_unpublish }
      end
    end
  end

  describe '#set_secret_token' do
    it 'updates token' do
      song.secret_token = nil
      expect do
        song.set_secret_token
      end.to change(song, :secret_token).from(nil)
    end
  end

  describe 'share_url' do
    let(:secret_token) { 'foo' }

    it 'returns correct url' do
      song.secret_token = secret_token
      expect(song.share_url)
        .to eql("/songs/#{song.friendly_id}?secret_token=#{secret_token}")
    end
  end

  describe 'evernote_url' do
    let(:secret_token) { 'foo' }

    it 'returns sandbox url' do
      expect(song.evernote_url)
        .to eql("https://sandbox.evernote.com/Home.action#n=#{song.guid}&s=s1&ses=4&sh=2&sds=5&")
    end

    context 'with environment production production' do
      it 'returns evernote.com url' do
        allow(Rails.env).to receive(:production?).and_return true
        expect(song.evernote_url)
          .to eql("https://www.evernote.com/client/web#?b=#{song.guid}&")
      end
    end
  end

  describe '#update_from_evernote' do
    let(:content) { 'foo' }
    let(:title) { 'bar' }
    let(:evernote_note) { double(:evernote_note, content:, title:) } # rubocop:disable RSpec/VerifiedDoubles

    it 'updates title' do
      expect do
        song.update_from_evernote(evernote_note)
      end.to change(song, :title).to(title)
    end

    it 'updates body' do
      expect do
        song.update_from_evernote(evernote_note)
      end.to change(song, :body).to(content)
    end
  end

  describe '#plain_text' do
    subject(:plain_text) { song.plain_text }

    let(:body) { '<p>Hello</p>' }
    let(:song) { build(:song, body:) }

    it { is_expected.to eql 'Hello' }
  end

  describe '#song_pro' do
    subject(:song_pro) { song.song_pro }

    let(:song) { build(:song) }

    it { is_expected.to be_a SongPro::Song }
  end

  describe '#chords' do
    subject(:chords) { song.chords }

    let(:song) { build(:song, body:) }

    context 'without chords' do
      let(:body) { '<p>Hello</p>' }

      it { is_expected.to eql [] }
    end

    context 'with simple chords' do
      let(:body) { '[C]Hello  [A] [C]' }

      it { is_expected.to eql %w[C A] }
    end

    context 'with annotated chords' do
      let(:body) { '[C]Hello  [A] [Riff 1]' }

      it { is_expected.to eql %w[C A] }
    end
  end

  describe '#album' do
    subject { song.album }

    let(:song) { build(:song, body:) }

    context 'with album in SongPro definition' do
      let(:body) { "@album=White Flag\n@album=Black Flag" }

      it { is_expected.to eq('Black Flag') }
    end

    context 'with album in ChordPro definition' do
      let(:body) { '{album:White Flag}' }

      it { is_expected.to be_nil }
    end

    context 'without album' do
      let(:body) { '[A] No song [D]here' }

      it { is_expected.to be_nil }
    end
  end

  describe '#year' do
    subject { song.year }

    let(:song) { build(:song, body:) }

    context 'with year in SongPro definition' do
      let(:body) { "@year=2007\n@year=2008" }

      it { is_expected.to eq('2008') }
    end

    context 'with year in ChordPro definition' do
      let(:body) { '{year:2002}' }

      it { is_expected.to be_nil }
    end

    context 'without defined year' do
      let(:body) { '[A] No song [D]here' }

      it { is_expected.to be_nil }
    end
  end

  describe '#capo' do
    subject { song.capo }

    let(:song) { build(:song, body:) }

    context 'with capo=2 in SongPro definition' do
      let(:body) { "@capo=2\n@capo=3" }

      it { is_expected.to eq('3') }
    end

    context 'with capo=two in SongPro definition' do
      let(:body) { "@capo=two\n@capo=3" }

      it { is_expected.to eq('3') }
    end

    context 'with capo in ChordPro definition' do
      let(:body) { '{capo:3}' }

      it { is_expected.to be_nil }
    end

    context 'without defined capo' do
      let(:body) { '[A] No song [D]here' }

      it { is_expected.to be_nil }
    end
  end

  describe '#tempo' do
    subject { song.tempo }

    let(:song) { build(:song, body:) }

    context 'when tempo=110 in SongPro definition' do
      let(:body) { "@tempo=110\n@tempo=112" }

      it { is_expected.to eq('112') }
    end

    context 'when tempo=two in SongPro definition' do
      let(:body) { "@tempo=two\n@tempo=112" }

      it { is_expected.to eq('112') }
    end

    context 'with tempo in ChordPro definition' do
      let(:body) { '{tempo:2002}' }

      it { is_expected.to be_nil }
    end

    context 'without defined tempo' do
      let(:body) { '[A] No song [D]here' }

      it { is_expected.to be_nil }
    end
  end

  describe '#key' do
    subject { song.key }

    let(:song) { build(:song, body:) }

    context 'with key in SongPro definition' do
      let(:body) { "@key=Am\n@key=A" }

      it { is_expected.to eq('A') }
    end

    context 'with key in ChordPro definition' do
      let(:body) { '{key:Am}' }

      it { is_expected.to be_nil }
    end

    context 'without defined key' do
      let(:body) { '[A] No song [D]here' }

      it { is_expected.to be_nil }
    end
  end

  describe '#verbose_key' do
    subject { song.verbose_key }

    let(:song) { build(:song, body:) }

    {
      'Ab' => 'a-flat',
      'A' => 'a',
      'Am' => 'a-minor',
      'A#' => 'a-sharp',
      'A#m' => 'a-sharp-minor',
      'Bb' => 'b-flat',
      'B' => 'b',
      'Bm' => 'b-minor',
      'Bbm' => 'b-flat-minor',
      'C' => 'c',
      'Cm' => 'c-minor',
      'C#' => 'c-sharp',
      'C#m' => 'c-sharp-minor',
      'Db' => 'd-flat',
      'Dbm' => 'd-flat-minor',
      'D' => 'd',
      'Dm' => 'd-minor',
      'D#' => 'd-sharp',
      'D#m' => 'd-sharp-minor',
      'Eb' => 'e-flat',
      'Ebm' => 'e-flat-minor',
      'E' => 'e',
      'Em' => 'e-minor',
      'Fm' => 'f-minor',
      'F' => 'f',
      'F#' => 'f-sharp',
      'F#m' => 'f-sharp-minor',
      'Gb' => 'g-flat',
      'Gbm' => 'g-flat-minor',
      'G' => 'g',
      'Gm' => 'g-minor',
      'G#' => 'g-sharp',
      'G#m' => 'g-sharp-minor'
    }.each do |key, expected_result|
      context "with key #{key}" do
        let(:body) { "@key=#{key}" }

        it { is_expected.to eq expected_result }
      end
    end

    context 'without set key' do
      let(:body) { '' }

      it { is_expected.to be_nil }
    end
  end

  describe '#key_url' do
    let(:song) { build(:song, body:) }
    let(:body) { '@key=Am' }
    let(:expected_url) { 'http://www.piano-keyboard-guide.com/key-of-a-minor.html' }

    it { expect(song.key_url).to eq expected_url }
  end
end
