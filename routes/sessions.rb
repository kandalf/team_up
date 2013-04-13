module TeamUp
  class Session < Cuba
    define do
      on ":provider/callback" do
        user = SessionManager.new(@env['omniauth.auth']).execute
      end

      on "failure" do
        res.headers["Content-type"] = "text/plain"
        res.write("Unauthorized")
      end
    end
  end
end
