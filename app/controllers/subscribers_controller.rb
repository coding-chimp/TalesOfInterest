class SubscribersController < ApplicationController
  before_filter :authenticate_user!

  def show
    @podcast = Podcast.find(params[:podcast])
    @subscribers = Subscriber.latest(@podcast)
    render layout: false
  end
end