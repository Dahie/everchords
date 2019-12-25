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
    let(:secret_token) { 'foo' }
    let(:id) { 42 }

    it 'returns correct url' do
      subject.secret_token = secret_token
      subject.id = 42
      expect(subject.share_url)
        .to eql("/songs/#{id}?secret_token=#{secret_token}")
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
end
