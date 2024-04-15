# frozen_string_literal: true

require 'spec_helper'

RSpec.describe UpdateNotebook, type: :interactor do
  subject(:call) { described_class.call(notebook:) }

  let(:user) { create(:user) }
  let(:evernote_notes) do
    [
      double(:note1, guid: '1', content: 'foo', title: 'bar'), # rubocop:disable RSpec/VerifiedDoubles
      double(:note1, guid: '2', content: 'baz', title: 'buu') # rubocop:disable RSpec/VerifiedDoubles
    ]
  end
  let(:notebook) { create(:notebook, user:) }

  before do
    allow_any_instance_of(EvernoteService) # rubocop:disable RSpec/AnyInstance
      .to receive(:notes)
      .and_return(evernote_notes)
  end

  describe '.call' do
    context 'without songs in notebook' do
      it 'creates two new songs' do
        expect do
          call
        end.to change(Song, :count).by(2)
      end
    end

    context 'with same songs as evernote in notebook' do
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

    context 'with more songs than evernote in notebook' do
      before do
        create(:song, notebook:, guid: '1')
        create(:song, notebook:, guid: '2')
        create(:song, notebook:, guid: '3')
      end

      it 'destroys old song1' do
        expect do
          call
        end.to change(Song, :count).by(-1)
      end
    end
  end
end
