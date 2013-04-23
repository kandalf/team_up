require 'pp'

module TeamUp
  class Session < Cuba
    define do
      on ":provider/callback" do
        user = SessionManager.new(@env['omniauth.auth'], self).execute

        if user && current_user.allowed?
          res.redirect "/dashboard"
        else
          logout(User) if user
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
