class EventsController < ApplicationController
  def index
    @events = Event.all

    render json: @events, status: :ok
  end
  def show
    @event = Event.find(params[:id])

    render json: @event, status: :ok
  end
end
