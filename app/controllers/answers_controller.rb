class AnswersController < ApplicationController
  before_action :authenticate_admin!
  layout 'admin'

  def new
    @answer = Answer.new
  end

  def create
    answer = Answer.create(answer_params)
    if answer.save
      flash[:notice] = "Successfully created new answer."
      redirect_to answers_path
    else
      flash[:alert] = "Could not create answer."
      render :new
    end
  end

  def index
    @answers = Answer.all
  end

  private

  def answer_params
    params.require(:answer).permit(:quiz_question_id, :answer, :correct)
  end

end
