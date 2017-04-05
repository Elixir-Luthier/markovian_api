defmodule MarkovianApi.Router.Homepage do
   use Maru.Router
   get do
     json(conn, %{ hello: :world })
   end
   params do
     requires :pm, type: List[List]
   end
   post "/getTm" do
     json(conn, %{tm: Markov.Utils.prob(params[:pm])})
   end
   params do
     requires :tm, type: List[List]
     requires :limit, type: Integer, values: 0..1000
   end
   post "/runChain" do
     {_,_,c,_} = Markov.Chain.run_chain({0, params[:tm], params[:limit]})
     json(conn, %{result: c})
   end
   params do
     requires :tm, type: List[List]
     requires :ps, type: Integer
   end
   post "/nextState" do
     json(conn, %{result: Markov.Chain.next_state(params[:ps], params[:tm])})
   end
 end
 defmodule MarkovianApi.API do
   use Maru.Router
   before do
     plug Plug.Logger
   end
   plug Plug.Parsers,
     pass: ["*/*"],
     json_decoder: Poison,
     parsers: [:urlencoded, :json, :multipart]

   mount MarkovianApi.Router.Homepage

   rescue_from :all do
     conn
     |> put_status(500)
     |> text("Server Error")
   end
 end
