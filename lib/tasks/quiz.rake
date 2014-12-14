namespace :quiz do
  desc "generate new quiz question"
  task create_new_question: :environment do
    # choose a blog post
    source_post = if ENV['BLOG_POST_ID']
      BlogPost.find(ENV['BLOG_POST_ID'])
    else
      BlogPost.approved.sample
    end
    QuizQuestion.create_from_blog_post!(source_post)
  end

  desc "build a new quiz"
  task build: :environment do
    # sample ten quiz questions

    # create a quiz with these questions

    # save the quiz question
  end
end
