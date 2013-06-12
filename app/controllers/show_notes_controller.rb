class ShowNotesController < ApplicationController
  def sort
    params[:show_note].each_with_index do |id, index|
      ShowNote.update_all({position: index+1}, {id: id})
    end
    render nothing: true
  end
end