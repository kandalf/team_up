class DashboardRoutes < Cuba
  settings[:render][:layout] = "layouts/application"

  define do
    on get do
      standups = Standup.for(Date.today).order_by(Sequel.desc(:date))
      my_standup = current_user.today_standup
      res.write view("dashboard/dashboard", {:standups => standups, :my_standup => my_standup})
    end
  end
end
