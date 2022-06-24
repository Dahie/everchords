# frozen_string_literal: true

require 'spec_helper'

RSpec.describe UpdateNotebook, type: :interactor do
  let(:user) { create(:user) }
  let(:notebook) { create(:notebook, user:) }
  subject(:call) { described_class.call(notebook:) }
  let(:evernote_notes) do
    [
      double(:note1, guid: '1', content: 'foo', title: 'bar'),
      double(:note1, guid: '2', content: 'baz', title: 'buu')
    ]
  end

  before do
    allow_any_instance_of(EvernoteService)
      .to receive(:notes)
      .and_return(evernote_notes)
  end

  describe '.call' do
    context 'notebook has no songs' do
      it 'creates two new songs' do
        expect do
          call
        end.to change { Song.count }.by(2)
      end
    end

    context 'notebook has same songs as evernote' do
      let!(:song1) do
        create(:song, notebook:, guid: '1', title: 'fu', body: 'ba')
      end

      it 'updates song title' do
        expect do
          call
        end.to change { song1.reload.title }.to 'bar'
      end

      it 'updates song body' do
        expect do
          call
        end.to change { song1.reload.body }.to 'foo'
      end
    end

    context 'notebook has more songs than evernote' do
      let!(:song1) { create(:song, notebook:, guid: '1') }
      let!(:song2) { create(:song, notebook:, guid: '2') }
      let!(:song3) { create(:song, notebook:, guid: '3') }

      it 'destroys old song1' do
        expect do
          call
        end.to change(Song, :count).by(-1)
      end
    end
  end
end
