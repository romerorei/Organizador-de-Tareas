class ApplicationController < ActionController::Base
    before_action :set_locale

    before_action :authenticate_user! # este metodo es nativo de devise
    # :authenticate_user! esto permite que solo los usuarios con sesion iniciada 
    # son los que puede interartuar entre los modelos, los scaffold o las rutas generdas


    # Con estos cuando salga un error de rails (pagina roja) nos redigira a el root_path
    rescue_from CanCan::AccessDenied do |exception|
        redirect_to root_path
    end


    def set_locale
        I18n.locale = 'es'
    end
end
