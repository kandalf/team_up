module TeamUp
  class Dashboard < Cuba
    define do
      on root do
        res.write render("./views/layouts/application.haml") {
          render("views/dashboard/dashboard.haml")
        }
      end

      on "dashboard" do
        res.redirect "/"
      end
    end
  end
end
