# frozen_string_literal: true

require 'spec_helper'

describe User do
  describe :validations do
    specify { expect(build(:user)).to be_valid }

    specify { expect(build(:user, email: '')).not_to be_valid }
    specify { expect(build(:user, email: nil)).not_to be_valid }

    specify { expect(build(:user, password: '')).not_to be_valid }
    specify { expect(build(:user, password: nil)).not_to be_valid }
  end

  describe :scopes do
  end

  describe '#from_omniauth' do
    let(:uid) { 4711 }
    let(:token) { 'secret token' }
    let(:auth) do
      double(provider: 'evernote',
             uid: uid,
             info: double(name: 'RosaPark', image: 'nope'),
             credentials: double(token: token))
    end

    context 'user does not exist yet' do
      it 'creates new user' do
        expect do
          User.from_omniauth(auth)
        end.to change(User, :count).by(1)
      end

      it 'stores evernote_token' do
        User.from_omniauth(auth)
        expect(User.last.evernote_token).to eq(token)
      end
    end

    context 'user does already exist' do
      let!(:user) { create(:user, uid: uid) }

      it 'creates no new user' do
        expect do
          User.from_omniauth(auth)
        end.to_not change(User, :count)
      end

      it 'stores evernote_token' do
        User.from_omniauth(auth)
        expect(User.last.evernote_token).to eq(token)
      end
    end
  end
end
