class CreateQuizQuestionsFromBlogPosts < ActiveRecord::Migration
  def up
    BlogPost.approved.each do |post|
      QuizQuestion.create_from_blog_post!(post)
    end
  end

  def down
    QuizQuestion.destroy_all
  end
end
