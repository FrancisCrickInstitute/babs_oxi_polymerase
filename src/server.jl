function start_server()
    f=joinpath(@__DIR__, "../www/anim_file.json")
    if !isfile(f)
        open(f, "w") do fname
            anim = main()
            write(fname, anim)
        end
    end

    staticfiles("www", "/")

    @post "/recalculate.json" function(request::HTTP.Request)
        return main(String(request.body))
    end
    
    @websocket "/ws" function(ws::HTTP.WebSocket)
        for msg in ws
            @info "Received message: $msg"
            send(ws,JSON.json(progress))
        end
    end
    
    @post "/get_bookmark.json" function(request::HTTP.Request)
         return main(String(request.body))
     end

    serve(host="0.0.0.0")
end

