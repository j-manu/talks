load :rack, :supervisor

rack "talk" do
  scheme "http"
  protocol { Async::HTTP::Protocol::HTTP1 }

  count 1

  endpoint do
    Async::HTTP::Endpoint.for(scheme, "127.0.0.1", port: 3000, protocol: protocol)
  end
end

supervisor
