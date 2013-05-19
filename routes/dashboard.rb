module TeamUp
  class Dashboard < Cuba
    define do
      on get do
        @standups = ::Standup.all.sort_by(:date, :order => "ALPHA DESC")
        @my_standup = current_user.today_standup
        res.write render("./views/layouts/application.haml") {
          render("views/dashboard/dashboard.haml")
        }
      end
    end
  end
end
