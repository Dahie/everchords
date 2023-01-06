# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Search' do
  describe 'GET /search' do
    let(:song) { create(:song) }

    context 'when user not logged in' do
      it do
        get('/search/seher')
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user logged in' do
      before do
        sign_in song.user
      end

      context 'without query' do
        it do
          get('/search/')
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with query' do
        it do
          get('/search/seh')
          expect(response).to have_http_status(:ok)
        end
      end
    end
  end
end
