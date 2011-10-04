class UserPresenter < BasePresenter
  presents :user

  def name
    user.name
  end

  def member_since
    user.created_at.strftime("%e %B %Y")
  end
end
