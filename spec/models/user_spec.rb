# frozen_string_literal: true

require 'spec_helper'

describe User do
  describe 'validations' do
    specify { expect(build(:user)).to be_valid }

    specify { expect(build(:user, email: '')).not_to be_valid }
    specify { expect(build(:user, email: nil)).not_to be_valid }

    specify { expect(build(:user, password: '')).not_to be_valid }
    specify { expect(build(:user, password: nil)).not_to be_valid }
  end

  describe '#from_omniauth' do
    let(:uid) { 4711 }
    let(:token) { 'secret token' }
    let(:auth) do
      double(provider: 'evernote', # rubocop:disable RSpec/VerifiedDoubles
             uid:,
             info: double(name: 'Rosa Park', image: 'nope'), # rubocop:disable RSpec/VerifiedDoubles
             credentials: double(token:)) # rubocop:disable RSpec/VerifiedDoubles
    end

    context 'without user' do
      it 'creates new user' do
        expect do
          described_class.from_omniauth(auth)
        end.to change(described_class, :count).by(1)
      end

      it 'stores evernote_token' do
        described_class.from_omniauth(auth)
        expect(described_class.last.evernote_token).to eq(token)
      end

      it 'stores faked email address' do
        described_class.from_omniauth(auth)
        expect(described_class.last.email).to eq('rosa-park@example.com')
      end
    end

    context 'with previous user' do
      before { create(:user, uid:) }

      it 'creates no new user' do
        expect do
          described_class.from_omniauth(auth)
        end.not_to change(described_class, :count)
      end

      it 'stores evernote_token' do
        described_class.from_omniauth(auth)
        expect(described_class.last.evernote_token).to eq(token)
      end
    end
  end
end
