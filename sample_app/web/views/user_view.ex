defmodule SampleApp.UserView do
  use SampleApp.Web, :view

  import Scrivener.HTML

  def is_empty_list?(list) when is_list(list) do
    list == []
  end
end
