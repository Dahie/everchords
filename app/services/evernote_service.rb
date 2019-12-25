# frozen_string_literal: true

class EvernoteService
  attr_reader :token

  def initialize(token)
    @token = token
  end

  def enutils
    @enutils ||= ENUtils::Core.new(token, Rails.env.production?)
  end

  def notes(notebook_name)
    enutils.notes(notebook: notebook_name, limit: 100)
  end

  delegate :notebooks, to: :enutils

  def notebook_names
    notebooks.map(&:name)
  end

  def note(guid)
    enutils.notestore.getNote(token, guid, true, true, false, false)
  end
end
