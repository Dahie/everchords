# frozen_string_literal: true

require 'spec_helper'

describe Song do
  describe :validations do
    specify { expect(build(:song)).to be_valid }

    specify { expect(build(:song, title: '')).not_to be_valid }
    specify { expect(build(:song, title: nil)).not_to be_valid }

    specify { expect(build(:song, notebook: nil)).not_to be_valid }

    specify { expect(build(:song, body: '')).not_to be_valid }
    specify { expect(build(:song, body: nil)).not_to be_valid }
  end

  describe :scopes do
  end

  describe '#may_publish?' do
    subject(:song) { build(:song, state: state) }

    ['draft', 'unpublished'].each do |state|
      context "song is #{state}" do
        let(:state) { state }

        specify { expect(song.may_publish?).to be_truthy }
      end
    end

    ['restricted', 'published'].each do |state|
      context "song is #{state}" do
        let(:state) { state }

        specify { expect(song.may_publish?).to be_falsey }
      end
    end
  end

  describe '#may_restrict?' do
    subject(:song) { build(:song, state: state) }

    ['published', 'unpublished'].each do |state|
      context "song is #{state}" do
        let(:state) { state }

        specify { expect(song.may_restrict?).to be_truthy }
      end
    end

    ['draft', 'restricted'].each do |state|
      context "song is #{state}" do
        let(:state) { state }

        specify { expect(song.may_restrict?).to be_falsey }
      end
    end
  end

  describe '#may_unpublish?' do
    subject(:song) { build(:song, state: state) }

    ['published'].each do |state|
      context "song is #{state}" do
        let(:state) { state }

        specify { expect(song.may_unpublish?).to be_truthy }
      end
    end

    ['draft', 'restricted', 'unpublished'].each do |state|
      context "song is #{state}" do
        let(:state) { state }

        specify { expect(song.may_unpublish?).to be_falsey }
      end
    end
  end

  subject { build(:song) }

  describe '#set_secret_token' do
    it 'updates token' do
      subject.secret_token = nil
      expect do
        subject.set_secret_token
      end.to change(subject, :secret_token).from(nil)
    end
  end

  describe 'share_url' do
    subject { create(:song) }
    let(:secret_token) { 'foo' }

    it 'returns correct url' do
      subject.secret_token = secret_token
      expect(subject.share_url)
        .to eql("/songs/#{subject.friendly_id}?secret_token=#{secret_token}")
    end
  end

  describe 'evernote_url' do
    subject { create(:song) }
    let(:secret_token) { 'foo' }

    it 'returns sandbox url' do
      expect(subject.evernote_url)
        .to eql("https://sandbox.evernote.com/Home.action#n=#{subject.guid}&s=s1&ses=4&sh=2&sds=5&")
    end

    context 'in production' do
      it 'returns evernote.com url' do
        allow(Rails.env).to receive(:production?).and_return true
        expect(subject.evernote_url)
          .to eql("https://www.evernote.com/client/web#?b=#{subject.guid}&")
      end
    end
  end

  describe '#update_from_evernote' do
    let(:content) { 'foo' }
    let(:title) { 'bar' }
    let(:evernote_note) do
      double(:evernote_note, content: content, title: title)
    end

    it 'updates title' do
      expect do
        subject.update_from_evernote(evernote_note)
      end.to change(subject, :title).to(title)
    end

    it 'updates body' do
      expect do
        subject.update_from_evernote(evernote_note)
      end.to change(subject, :body).to(content)
    end
  end

  describe '#plain_text' do
    let(:body) { "<p>Hello</p>" }
    let(:song) { build(:song, body: body) }
    subject(:plain_text) { song.plain_text }

    it { is_expected.to eql 'Hello' }
  end

  describe '#song_pro' do
    let(:song) { build(:song) }
    subject(:song_pro) { song.song_pro }

    it { is_expected.to be_a SongPro::Song }
  end

  describe '#chords' do
    let(:song) { build(:song, body: body) }
    subject(:chords) { song.chords }

    context 'without chords' do
      let(:body) { "<p>Hello</p>" }

      it { is_expected.to eql [] }
    end

    context 'with simple chords' do
      let(:body) { "[C]Hello  [A] [C]" }

      it { is_expected.to eql ['C', 'A'] }
    end

    context 'with annotated chords' do
      let(:body) { "[C]Hello  [A] [Riff 1]" }

      it { is_expected.to eql ['C', 'A'] }
    end
  end

  describe '#album' do
    let(:song) { build(:song, body: body) }
    subject { song.album }

    context 'album in SongPro definition' do
      let(:body) { "@album=White Flag\n@album=Black Flag" }

      it { is_expected.to eq('Black Flag') }
    end

    context 'album in ChordPro definition' do
      let(:body) { "{album:White Flag}" }

      it { is_expected.to be_nil }
    end

    context 'album not defined' do
      let(:body) { "[A] No song [D]here" }

      it { is_expected.to be_nil }
    end
  end

  describe '#year' do
    let(:song) { build(:song, body: body) }
    subject { song.year }

    context 'year in SongPro definition' do
      let(:body) { "@year=2007\n@year=2008" }

      it { is_expected.to eq('2008') }
    end

    context 'year in ChordPro definition' do
      let(:body) { "{year:2002}" }

      it { is_expected.to be_nil }
    end

    context 'year not defined' do
      let(:body) { "[A] No song [D]here" }

      it { is_expected.to be_nil }
    end
  end

  describe '#capo' do
    let(:song) { build(:song, body: body) }
    subject { song.capo }

    context 'capo in SongPro definition' do
      let(:body) { "@capo=2\n@capo=3" }

      it { is_expected.to eq('3') }

      context 'value not a number' do
        let(:body) { "@capo=two\n@capo=two" }

        it { is_expected.to be_nil }
      end
    end

    context 'capo in ChordPro definition' do
      let(:body) { "{capo:3}" }

      it { is_expected.to be_nil }
    end

    context 'capo not defined' do
      let(:body) { "[A] No song [D]here" }

      it { is_expected.to be_nil }
    end
  end

  describe '#tempo' do
    let(:song) { build(:song, body: body) }
    subject { song.tempo }

    context 'tempo in SongPro definition' do
      let(:body) { "@tempo=110\n@tempo=112" }

      it { is_expected.to eq('112') }

      context 'value not a number' do
        let(:body) { "@tempo=two\n@tempo=two" }

        it { is_expected.to be_nil }
      end
    end

    context 'tempo in ChordPro definition' do
      let(:body) { "{tempo:2002}" }

      it { is_expected.to be_nil }
    end

    context 'tempo not defined' do
      let(:body) { "[A] No song [D]here" }

      it { is_expected.to be_nil }
    end
  end

  describe '#key' do
    let(:song) { build(:song, body: body) }
    subject { song.key }

    context 'tempo in SongPro definition' do
      let(:body) { "@key=Am\n@key=A" }

      it { is_expected.to eq('A') }
    end

    context 'tempo in ChordPro definition' do
      let(:body) { "{key:Am}" }

      it { is_expected.to be_nil }
    end

    context 'tempo not defined' do
      let(:body) { "[A] No song [D]here" }

      it { is_expected.to be_nil }
    end
  end

  describe '#verbose_key' do
    let(:song) { build(:song, body: body) }
    subject { song.verbose_key }

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
      'G#m' => 'g-sharp-minor',
    }.each do |key, expected_result|
      context "with key #{key}" do
        let(:body) { "@key=#{key}" }
        it { is_expected.to eq expected_result }
      end
    end

    context 'key is not set' do
      let(:body) { "" }
      it { is_expected.to eq nil }
    end
  end

  describe '#key_url' do
    let(:song) { build(:song, body: body) }
    let(:body) { "@key=Am" }
    let(:expected_url) { "http://www.piano-keyboard-guide.com/key-of-a-minor.html" }

    it { expect(song.key_url).to eq expected_url }
  end

end
