# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Pages', type: :request do
  %i[help imprint].each do |page|
    describe "GET /#{page}" do
      it do
        get("/#{page}")
        expect(response).to render_template(page)
      end
    end
  end
end
