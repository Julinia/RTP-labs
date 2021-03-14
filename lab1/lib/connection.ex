defmodule Connection do

  def start_connection(url) do
    EventsourceEx.new(url, stream_to: self())
    get_data_stream()
  end

  def get_data_stream() do
    receive do
      tweet -> Manager.manage(tweet)
      get_data_stream()
    end
  end

end