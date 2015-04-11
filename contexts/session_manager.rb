require 'pp'
require 'json'

class SessionManager
  def initialize(auth_hash, ctx)
    pp auth_hash
    @ctx = ctx
    @info = auth_hash["info"]
    @uid = auth_hash["uid"]
    @extra = auth_hash["extra"]
    @info["password"] = "#{@info["nickname"]}_#{@uid}"
  end

  def execute
    @user = User.fetch(@info["nickname"])

    @user = create_user if @user.nil?

    set_organizations

    @ctx.login(User, @user.github_user, @info["password"])
  end

  
  private
  def create_user
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

  def set_organizations
    #begin
      #response = RestClient.get(@extra["raw_info"]["organizations_url"])
      #orgs = JSON.parse(response)

      #orgs.each do |org|
        #unless @user.organizations.include? org["login"]
          #@user.organizations << org["login"]
        #end
      #end

      #@user.save
    #rescue
      #@user.organizations ||= ""
    #end
  end
end
