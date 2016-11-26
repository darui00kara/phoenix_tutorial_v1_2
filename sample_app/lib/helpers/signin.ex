defmodule SampleApp.Helpers.Signin do
  import SampleApp.Authentication

  def signin(user, password) do
    case authentication(user, password) do
      true -> {:ok, user}
         _ -> :error
    end
  end
end
