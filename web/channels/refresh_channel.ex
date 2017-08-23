defmodule UpsilonBattle.RefreshChannel do
  use UpsilonBattle.Web, :channel
  require Logger
#
#     Channels
# 
#     UpsilonBattle.Endpoint. 
#
#     subscribe(topic, opts) - subscribes the caller to the given topic. See Phoenix.PubSub.subscribe/3 for options.
# 
#     unsubscribe(topic) - unsubscribes the caller from the given topic.
# 
#     broadcast(topic, event, msg) - broadcasts a msg with as event in the given topic.
# 
#     broadcast!(topic, event, msg) - broadcasts a msg with as event in the given topic. Raises in case of failures.
# 
#     broadcast_from(from, topic, event, msg) - broadcasts a msg from the given from as event in the given topic.
#     broadcast_from!(from, topic, event, msg) - broadcasts a msg from the given from as event in the given topic. Raises in case of failures.
# 

def refresh_all_players() do 
    UpsilonBattle.Endpoint.broadcast "refresh", "refresh:lobby", %{}
  end

  def join("refresh:lobby", payload, socket) do
    Logger.info "New user joined Refresh socket ! provided params: #{inspect(payload)}"
    if authorized?(payload)  do 
        engine = UpsilonBattle.EngineStore.get()
        {:ok, engine} = UpsilonBattle.Engine.register_user_socket(engine, String.to_integer(payload["user_id"]), socket)
        UpsilonBattle.EngineStore.set(engine)
        {:ok, socket}
    else 
        Logger.error "User is unexpected."
        {:error, %{reason: "unexpected"}}
    end
  end

  def join(channel, _params, _socket) do
    Logger.error "Unauthorized access to weird channel. #{channel}"
    {:error, %{reason: "unauthorized"}}
  end


  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (refresh:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(params) do
    engine = UpsilonBattle.EngineStore.get()
    UpsilonBattle.Engine.user_known?(engine,String.to_integer(params["user_id"]))
  end
end
