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
end
