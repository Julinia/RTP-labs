defmodule Command do
  def parse(line) do
    case String.split(line, " ", parts: 3) |> Enum.map(fn string -> String.trim(string) end) do      
      ["PUBLISH", subject, data] -> {:ok, {:publish, subject, data}}
      ["SUBSCRIBE", subject] -> {:ok, {:subscribe, subject}}
      _ -> {:error, :unknown_command}
    end
  end

  def run(command, socket)

  def run({:publish, subject, data}, socket) do
    all_subscribers = Registry.get_by_subject(subject)

    Enum.each(all_subscribers, fn subscriber -> TCPServer.write_line(subscriber.subscriber, {:for_subscriber, data}) end)
    {:ok, "OK\r\n"}
  end

  def run({:subscribe, subject}, socket) do
    Registry.add_subs(subject, socket)
    {:ok, "OK\r\n"}
  end
end