class SessionManager
  def initialize(auth_hash)
    pp auth_hash
    @info = auth_hash["info"]
    @uid = auth_hash["uid"]
    @extra = auth_hash["extra"]
  end

  def execute
    @user = User.fetch(@info["nickname"])

    @user = create_user if @user.nil?

    require 'debugger'
    debugger
    Shield::Helpers.login(User, @user.github_user, @info["password"])
  end
  
  private
  def create_user
    @info["password"] = "#{@info["nickname"]}_#{@uid}"
    user = User.new(
      :full_name => @info["name"],
      :github_user => @info["nickname"],
      :email => @info["email"],
      :gravatar_url => @info["image"],
    )

    user.password = @info["password"]
    user.save
    user
  end
end
