require 'pp'

module TeamUp
  class Session < Cuba
    define do
      on ":provider/callback" do
        user = SessionManager.new(@env['omniauth.auth'], self).execute

        if user
          res.redirect "/dashboard"
        else
          session['flash.error'] = 'Unauthorized User'
          res.redirect '/'
        end
      end

      on "failure" do
        res.headers["Content-type"] = "text/plain"
        res.write("Unauthorized")
      end
    end
  end
end
