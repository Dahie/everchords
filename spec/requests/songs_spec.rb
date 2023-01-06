# frozen_string_literal: true

require 'spec_helper'

describe 'Songs' do
  describe '#show' do
    let(:song) { create(:song) }

    context 'without song of given slug' do
      it 'renders not_found view' do
        get('/songs/unknown_slug')
        expect(response).to render_template(:not_found)
      end
    end

    context 'when user not logged in' do
      context 'without secret token' do
        it 'renders not_found view' do
          get("/songs/#{song.slug}")
          expect(response).to render_template(:not_found)
        end
      end

      context 'with secret token' do
        it 'renders show view' do
          get("/songs/#{song.slug}", params: { secret_token: song.secret_token })
          expect(response).to render_template(:show)
        end
      end

      context 'when song is published' do
        it 'renders show view' do
          song.update(state: :published)
          get("/songs/#{song.slug}")
          expect(response).to render_template(:show)
        end
      end
    end

    context 'when user logged in' do
      context 'without secret token' do
        it 'renders show view' do
          sign_in song.user
          get("/songs/#{song.slug}")
          expect(response).to render_template(:show)
        end
      end

      context 'with song not owned by user' do
        let(:song2) { create(:song) }

        it 'renders not_found view' do
          sign_in song.user
          get("/songs/#{song2.slug}")
          expect(response).to render_template(:not_found)
        end
      end
    end
  end
end
