class NotificationsController < ApplicationController
  
  def index
    @notifications = current_user.notifications.order("created_at DESC")
  end

  def read
    @notification = current_user.notifications.find(params[:id])
    @notification.mark_as_read
  end
end
