require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    @letters = alphabet.sample(10)
  end

  def score
    @score = 0
    @letters = params[:letters]
    params[:word].upcase.split("").each do |letter|
      if @letters.include?(letter)
        @score += 1
        @letters.delete!(letter)
      else
        @score = "Sorry, but #{params[:word]} can't be built out of these letters: #{@letters}"
        break
      end
    end
    if session[:current_user_id].nil?
      session[:current_user_id] = 0
    end
    if @score.class == Integer
      session[:current_user_id] += @score
      @score_total = session[:current_user_id]
      @score = "Congratulations, your score is #{@score}"
    end
    url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
    user_serialized = URI.open(url).read
    user = JSON.parse(user_serialized)
    unless user["found"]
      @score = "Sorry, but #{params[:word]} is not a valid english word."
    end
  end
end
