class QuizQuestion < ActiveRecord::Base
  belongs_to :quiz
  has_many :answers

  def preview
    line_count = 1
    preview = ''
    self.question.each_line do |line|
      preview += line unless line_count > 10
      line_count += 1
    end
    preview
  end

  def self.create_from_blog_post!(source_post)
     # create a quiz question with the content of the post as the question
    question = QuizQuestion.new
    question.question = source_post.preview
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
end
