require 'sinatra/base'
require 'json'
require_relative 'ledger'

module ExpenseTracker
  class API < Sinatra::Base
    def initialize(ledger: Ledger.new)
      @ledger = ledger
      super()
    end

    post '/expenses' do
      expense = JSON.parse(request.body.read)
      result = @ledger.record(expense)

      if result.success?
        JSON.generate('expense_id' => result.expense_id)
      else
        status 422
        JSON.generate('error' => result.error_message)
      end
    end

    get '/expenses/:date' do
      result = @ledger.expense_on(:date)
      if result.success?
        JSON.generate('expense' => result.expense)
      else
        status 422
        JSON.generate('error' => result.error_message)
      end
    end
  end
end
