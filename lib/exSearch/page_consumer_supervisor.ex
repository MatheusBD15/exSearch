defmodule ExSearch.PageConsumerSupervisor do
  use ConsumerSupervisor
  require Logger

  def start_link(_args) do
    ConsumerSupervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    # start the actual page consumer as children
    children = [
      %{
        id: ExSearch.PageConsumer,
        start: {ExSearch.PageConsumer, :start_link, []},
        restart: :transient
      }
    ]

    # subscribe to the page producer
    # max_demand can be used to limit concurrent consumer processes
    # here we are configuring only 2 concurrent processes
    opts = [
      strategy: :one_for_one,
      subscribe_to: [
        {ExSearch.PageProducer, max_demand: 1}
      ]
    ]

    ConsumerSupervisor.init(children, opts)
  end
end
