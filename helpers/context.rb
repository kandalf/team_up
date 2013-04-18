module TeamUp
  module Context
    def current_user
      authenticated(User)
    end
  end
end
