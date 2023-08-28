require "open-uri"
require "async"

class BenchmarkController < ApplicationController
  def external
    JSON.parse URI.open("https://httpbingo.org/delay/1").read
    render plain: "OK"
  end

  def io
    task = Async::Task.new

    tasks = []

    tasks << task.async do
      @resp = JSON.parse URI.open("https://httpbingo.org/delay/2").read
    end

    tasks << task.async do
      @resp2 = JSON.parse URI.open("https://httpbingo.org/delay/2").read
    end

    tasks.map(&:wait)

    render plain: "#{@resp["method"]} #{@resp2["method"]}"
  end

  def io2
    tasks = []

    tasks << Async do
      @resp = JSON.parse URI.open("https://httpbingo.org/delay/2").read
    end

    tasks << Async do
      @resp2 = JSON.parse URI.open("https://httpbingo.org/delay/2").read
    end

    tasks.map(&:wait)

    render plain: "#{@resp["method"]} #{@resp2["method"]}"
  end

  def cpu
    render plain: fib(params[:n].present? ? params[:n].to_i : 10)
  end

  def synthetic
    sleep_duration = params[:sleep].present? ? params[:sleep].to_i : 0.1
    # num = params[:num].present? ? params[:num].to_i : 10
    sleep sleep_duration

    @posts = []
    100.times do
      @posts << Post.new(title: Faker::Book.title, body: Faker::Lorem.paragraph)
    end

    # render plain: "Slept for #{sleep_duration} seconds, fibonacci for #{num} is #{fib(num)}"
  end

  private

  def fib(n)
    (n < 2) ? n : (fib(n - 1) + fib(n - 2))
  end
end
