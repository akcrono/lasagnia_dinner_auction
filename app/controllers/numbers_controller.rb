class NumbersController < ApplicationController

	def show
		@number = params['numbers']
	end
end