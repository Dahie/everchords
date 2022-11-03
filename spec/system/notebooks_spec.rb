# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Notebook', type: :system, inaccessible: true do
  let(:user) { create(:user) }
  let!(:notebook1) { create(:notebook, user:) }
  let!(:notebook2) { create(:notebook, user:) }

  before do
    evernote_service = instance_double(EvernoteService)
    allow(EvernoteService).to receive(:new).with(user.evernote_token).and_return(evernote_service)
    allow(evernote_service).to receive(:notebook_names).and_return(['Unknown Notebook'])
  end
  
  xit 'shows 2 notebooks' do
    sign_in(user)
    visit(root_path)
    expect(page).to have_text(notebook1.name)
    expect(page).to have_text(notebook2.name)
    expect(page).to have_selector('a.notebook.item', visible: true)
  end
end
