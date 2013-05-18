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
  end
 end
end
