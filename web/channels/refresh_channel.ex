defmodule UpsilonBattle.RefreshChannel do 
    use Phoenix.Channel

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
    UpsilonBattle.Endpoint.broadcast "refresh", "", %{}
  end

  def join("refresh", _message, socket) do
    {:ok, socket}
  end

  def join(_, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  # On a pas besoin ni d'handle_in ni d'handle_out
  # On veux juste dire a tout le monde de se refresh ;) 

end