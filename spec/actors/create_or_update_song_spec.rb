# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CreateOrUpdateSong, type: :interactor do
  subject(:call) do
    described_class.call(evernote_note:,
                         notebook:,
                         user:)
  end

  let(:user) { create(:user) }
  let(:evernote_note) { double(:note1, guid: '1', content: 'foo', title: 'bar') } # rubocop:disable RSpec/VerifiedDoubles
  let(:notebook) { create(:notebook, user:) }

  describe '.call' do
    context 'without songs' do
    it 'creates one new songs' do
        expect do
          call
        end.to change(Song, :count).by(1)
    end
    end

    context 'with song' do
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
