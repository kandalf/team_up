class Cuba
  class Response
    attr_accessor :flash

    alias_method :orig_redirect, :redirect

    #FIXME: Still not working. On Redirect we got a different object
    #so we need to access the app or the session.
    def redirect(path, flash = {}, status = 302)
      @flash = flash
      orig_redirect(path, status)
    end
  end

  def flash
    session['cuba.flash'] ||= (@env['rack.session']['cuba.flash'] || {})
    session['cuba.flash']
  end
end
