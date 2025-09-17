class PrintMessageJob < ApplicationJob
  queue_as :default

  def perform(message)
    # Do something later
    puts "JOBちゃんと動いてる？？引数は#{message}"
  end
end
