class RoomChannel < ApplicationCable::Channel
  def subscribed
    logger.info "Subscribed to RoomChannel Room ID: #{params[:room_id]}"

    @room = Room.find(params[:room_id])

    stream_from "room_channel_#{@room.id}"

    speak('message' => '* * * joined the room * * *')
  end

  def unsubscribed
    logger.info 'Unsubscribed from RoomChannel'

    speak('message' => '* * * left the room * * *')
  end

  def speak(data)
    logger.info "RoomChannel, speak: #{data.inspect}"

    MessageService.new(
      body: data['message'], user: current_user, room: @room
    ).perform
  end
end
