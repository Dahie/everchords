# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    if current_user
      @notebook = Notebook.new
      @evernote_notebooks = evernote_notebooks
    end
  end

  private

  def notebook_names
    notebooks.map(&:name)
  end

  def notebooks
    current_user.notebooks
  end

  def evernote_notebooks
    evernote_service.notebook_names.reject { |name| name.in?(notebook_names) }
  rescue Net::OpenTimeout => e
    []
  end
end
