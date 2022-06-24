# frozen_string_literal: true

module SongStateMachine
  extend ActiveSupport::Concern

  included do
    include AASM

    aasm(column: 'state') do
      state :draft, initial: true
      state :published, :unpublished, :restricted

      event :publish do
        transitions from: %i[draft unpublished], to: :published
      end

      event :unpublish do
        transitions from: :published, to: :unpublished
      end

      event :restrict do
        transitions from: %i[unpublished published], to: :restricted
      end
    end
  end
end
