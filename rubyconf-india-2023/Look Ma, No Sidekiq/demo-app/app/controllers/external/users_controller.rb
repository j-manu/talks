class External::UsersController < ApplicationController
  def index
    url = "https://reqres.in/api/users?delay=3"
    @users = JSON.parse(URI.open(url).read)["data"]
  end
end
