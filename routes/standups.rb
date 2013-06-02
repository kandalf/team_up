module TeamUp
 class Standup < Cuba
  define do
    on post, param("standup") do |params|
      standup = StandupCreator.new(params, self).execute
      if standup.valid?
        flash[:success] = "Standup created"
      else
        flash[:error] = "Standup Cannot be created"
      end
      res.redirect("/dashboard")
    end

    on get do
      on root do
        today_standups = ::Standup.for(Date.today)
        previous = ::Standup.last_ones

        res.write render("./views/layouts/application.haml") {
          render("views/standups/index.haml", {:for_today => today_standups, :previous => previous})
        }
      end

      on ":id/edit" do |id|
        standup = current_user.standups[id]

        if standup
          res.write render("./views/layouts/application.haml") {
            render("views/standups/edit.haml", {:standup => standup})
          }
        else
          res.status = 404
          res.write("Not Found")
        end
      end
    end
  end
 end
end
