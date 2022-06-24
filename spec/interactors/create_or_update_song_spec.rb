# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CreateOrUpdateSong, type: :interactor do
  let(:user) { create(:user) }
  let(:notebook) { create(:notebook, user:) }
  subject(:call) do
    described_class.call(evernote_note:,
                         notebook:,
                         user:)
  end
  let(:evernote_note) do
    double(:note1, guid: '1', content: 'foo', title: 'bar')
  end

  describe '.call' do
    context 'songs does not exist' do
      it 'creates one new songs' do
        expect do
          call
        end.to change { Song.count }.by(1)
      end
    end

    context 'song exist' do
      let!(:song) do
        create(:song, notebook:, guid: '1', title: 'fu', body: 'ba')
      end

      it 'updates song title' do
        expect do
          call
        end.to change { song.reload.title }.to 'bar'
      end

      it 'updates song body' do
        expect do
          call
        end.to change { song.reload.body }.to 'foo'
      end
    end
  end
end
