# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, ::Song, public: true

    if user.present?  # additional permissions for logged in users (they can read their own posts)
      can :manage, [::Song, ::Notebook], user_id: user.id

      if user.admin?  # additional permissions for administrators
        can :access, :rails_admin       # only allow admin users to access Rails Admin
        can :read, :dashboard           # allow access to dashboard
        can :manage, :all
      end
    end

    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
