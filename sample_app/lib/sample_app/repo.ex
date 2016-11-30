defmodule SampleApp.Repo do
  use Ecto.Repo, otp_app: :sample_app
  use Scrivener, page_size: 30
end
