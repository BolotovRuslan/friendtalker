class UserstatusChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'userstatus_channel'

    user_went

    update_status
  end

  def unsubscribed
    user_left

    update_status
  end

  def left_site
    user_left

    update_status
  end

  def update_status
    ActionCable.server.broadcast 'userstatus_channel', { user: current_user }
  end

  private

  def user_left
    current_user.update!(status: false)
  end

  def user_went
    current_user.update!(status: true)
  end
end
