class ShowNotesController < ApplicationController
  def sort
    params[:show_note].each_with_index do |id, index|
      ShowNote.update_all({position: index+1}, {id: id})
    end
    render nothing: true
  end

  def post
    podcast = Podcast.find_by_name(params[:podcast])
    @episode = podcast.last_episode
    ShowNote.create(episode: @episode, url: params[:u], name: params[:t])
  end
end