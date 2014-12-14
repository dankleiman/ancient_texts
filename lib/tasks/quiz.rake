namespace :quiz do
  desc "generate new quiz question"
  task create_new_question: :environment do
    # choose a blog post
    source_post = BlogPost.approved.sample
    # create a quiz question with the content of the post as the question
    question = QuizQuestion.new
    question.question = source_post.body
    # add the correct answer as the book author and title of the post
    question.answers.build(answer: source_post.book.author_and_title, correct: true)
    # pick two more blog posts at random as the incorrect answers
    books = Book.approved.reject { |book| book == source_post.book }.sample(2)
    books.each do |book|
      question.answers.build(answer: book.author_and_title, correct: false)
    end
    # save the quiz question
    question.save!
  end

  desc "build a new quiz"
  task build: :environment do
    # sample ten quiz questions

    # create a quiz with these questions

    # save the quiz question
  end
end
