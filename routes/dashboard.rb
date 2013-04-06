module TeamUp
  class Dashboard < Cuba
    define do
      on root do
        res.redirect "/dashboard"
      end

      on "dashboard" do
        res.write render("./views/layouts/application.haml") {
          render("views/dashboard/dashboard.haml")
        }
      end
    end
  end
end
