module TeamUp
  class Dashboard < Cuba
    define do
      on root do
        res.redirect "/dashboard"
      end

      on "dashboard" do
        @standups = ::Standup.all.sort(:order => "DESC")
        res.write render("./views/layouts/application.haml") {
          render("views/dashboard/dashboard.haml")
        }
      end

      on "/sessions/create" do
        puts "GET"
        puts env
        puts @env
      end
    end
  end
end
