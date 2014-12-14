class CreateQuestionsAndAnswers < ActiveRecord::Migration
  def change
    create_table :quizzes do |t|

      t.timestamps
    end

    create_table :quiz_questions do |t|
      t.text :question

      t.timestamps
    end

    create_table :answers do |t|
      t.string :answer
      t.integer :quiz_question_id
      t.boolean :correct

      t.timestamps
    end
  end
end
