class NotebooksController < ApplicationController

  def new
    @notebook = Notebook.new
    notebook_names = current_user.notebooks.map { |book| book.name }
    @evernote_notebooks = evernote_service.notebooks.map { |book| book.name }.reject { |name| name.in?(notebook_names) }
  end

  def create
    @notebook = current_user.notebooks.create(permitted_params)
    evernote_service.notes(@notebook.name).each do |evernote_note|
      song = Song.find_or_initialize_by(guid: evernote_note.guid)
      song.update_from_evernote(evernote_note)
      song.user = current_user
      song.notebook = @notebook
      song.save!
    end

    redirect_to root_path, notice: "Notebook #{@notebook.name} succesfully created"
  end


  def destroy
    @notebook = Notebook.find(params[:id])
    message = if @notebook.destroy
      "Notebook #{@notebook.name} succesfully created"
    else
      "Notebook #{@notebook.name} could not be delete"
    end
    redirect_to root_path, alert: message
  end

  private

  def permitted_params
    params.require(:notebook).permit(:name)
  end

end
