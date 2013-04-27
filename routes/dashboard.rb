module TeamUp
  class Dashboard < Cuba
    define do
      on get do
        @standups = ::Standup.all.sort(:by => :date, :order => "DESC")
        res.write render("./views/layouts/application.haml") {
          render("views/dashboard/dashboard.haml")
        }
      end
    end
  end
end
