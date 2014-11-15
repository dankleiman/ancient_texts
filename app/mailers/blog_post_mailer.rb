class BlogPostMailer < ActionMailer::Base
  default from: "support@ancientwisdomtexts.com"

  def new_post(user, post)
    @user = user
    @post = post

    mail(to: @user.email, subject: 'New Post on AncientWisdomTexts.com')
  end
end
