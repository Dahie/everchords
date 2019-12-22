require 'spec_helper'

describe User do
  describe :validations do
    specify { expect(build(:user)).to be_valid }

    specify { expect(build(:user, email: "")).not_to be_valid }
    specify { expect(build(:user, email: nil)).not_to be_valid }

    specify { expect(build(:user, password: "")).not_to be_valid }
    specify { expect(build(:user, password: nil)).not_to be_valid }
  end

  describe :scopes do

  end

end
