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
end
