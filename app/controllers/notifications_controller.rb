class NotificationsController < ApplicationController
  def index
    @notifications = Notification.find_by_user(current_user)
  end
end
