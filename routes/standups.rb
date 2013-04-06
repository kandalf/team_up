require './contexts/standup_creator'

module TeamUp
 class Standup < Cuba
  define do
    on post, param("standup") do |params|
      standup = StandupCreator.new(params).execute
      if standup.valid?
        res.redirect("/", :success => "Standup created")
      else
        res.redirect("/", :error => "Standup Cannot be created")
      end
    end
  end
 end
end
