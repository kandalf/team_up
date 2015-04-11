module TeamUp
  class Dashboard < Cuba
    #Cuba.settings[:render][:layout] = "layouts/application"

    define do
      on get do
        @standups = ::Standup.for(Date.today).order_by(Sequel.desc(:date))
        @my_standup = current_user.today_standup
        res.write render("dashboard/dashboard", {}, "layouts/application")
      end
    end
  end
end
