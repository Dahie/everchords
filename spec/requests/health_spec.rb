# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Health', type: :request do
  describe 'GET /health' do
    it do
      get('/health')
      expect(response).to have_http_status(:ok)
    end
  end
end
