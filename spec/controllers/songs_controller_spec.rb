# frozen_string_literal: true

require 'spec_helper'

describe SongsController do
  describe '#show' do
    let(:song) { create(:song) }

    context 'no song with given slug' do
      it 'renders not_found view' do
        get(:show, params: { id: 'unknown_slug'})
        expect(response).to render_template(:not_found)
      end
    end

    context 'user not logged in' do
      context 'without secret token' do
        it 'renders not_found view' do
          get(:show, params: { id: song.slug })
          expect(response).to render_template(:not_found)
        end
      end

      context 'with secret token' do
        it 'renders show view' do
          get(:show, params: { id: song.slug, secret_token: song.secret_token })
          expect(response).to render_template(:show)
        end
      end
    end

    context 'user not logged in' do
      context 'without secret token' do
        it 'renders show view' do
          allow(controller).to receive(:current_user).and_return(song.user)
          get(:show, params: { id: song.slug })
          expect(response).to render_template(:show)
        end

        context 'song is published' do
          it 'renders show view' do
            song.update(state: :published)
            get(:show, params: { id: song.slug })
            expect(response).to render_template(:show)
          end
        end
      end

      context 'song not owned by user' do
        let(:song2) { create(:song) }
        it 'renders not_found view' do
          allow(controller).to receive(:current_user).and_return(song.user)
          get(:show, params: { id: song2.slug })
          expect(response).to render_template(:not_found)
        end
      end
    end
  end
end
