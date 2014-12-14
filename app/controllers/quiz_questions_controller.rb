class QuizQuestionsController < ApplicationController
  before_action :authenticate_admin!
  layout 'admin'

  def new
    @quiz_question = QuizQuestion.new
  end

  def create
    quiz_question = QuizQuestion.create(quiz_question_params)
    if quiz_question.save
      flash[:notice] = "Successfully created new quiz question."
      redirect_to quiz_questions_path
    else
      flash[:alert] = "Could not create quiz question."
      render :new
    end
  end

  def index
    @quiz_questions = QuizQuestion.all
  end

  private

  def quiz_question_params
    params.require(:quiz_question).permit(:question, :answer)
  end

end
