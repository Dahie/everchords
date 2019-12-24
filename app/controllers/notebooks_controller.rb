# frozen_string_literal: true

class NotebooksController < ApplicationController
  before_action :load_notebook, only: %i[update destroy]
  before_action :authenticate_user!, only: %i[update destroy]

  def new
    @notebook = Notebook.new
    @evernote_notebooks = evernote_service.notebook_names.reject { |name| name.in?(notebook_names) }
  end

  def create
    @notebook = notebooks.create(permitted_params)
    @notebook.update_notes(evernote_notes)

    redirect_to root_path, notice: "Notebook \"#{@notebook.name}\" succesfully created"
  end

  def update
    @notebook.update_notes(evernote_notes)

    redirect_to root_path, notice: "Notebook \"#{@notebook.name}\" succesfully updated"
  end

  def destroy
    message = if @notebook.destroy
                "Notebook \"#{@notebook.name}\" succesfully created"
              else
                "Notebook \"#{@notebook.name}\" could not be deleted"
    end
    redirect_to root_path, alert: message
  end

  private

  def load_notebook
    @notebook = Notebook.find(params[:id])
  end

  def evernote_notes
    evernote_service.notes(@notebook.name)
  end

  def notebook_names
    notebooks.map(&:name)
  end

  def notebooks
    current_user.notebooks
  end

  def permitted_params
    params.require(:notebook).permit(:name)
  end
end
