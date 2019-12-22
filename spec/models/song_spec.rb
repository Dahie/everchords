require 'spec_helper'

describe Song do
  describe :validations do

    specify { expect(build(:song)).to be_valid }

    specify { expect(build(:song, title: "")).not_to be_valid }
    specify { expect(build(:song, title: nil)).not_to be_valid }

    specify { expect(build(:song, notebook: nil)).not_to be_valid }

    specify { expect(build(:song, body: "")).not_to be_valid }
    specify { expect(build(:song, body: nil)).not_to be_valid }
  end

  describe :scopes do

  end

  subject { create(:song) }

  describe 'set_secret_token' do
    it 'updates token' do
      subject.secret_token = nil
      expect {
        subject.set_secret_token
      }.to change(subject, :secret_token).from(nil)
    end
  end
end
