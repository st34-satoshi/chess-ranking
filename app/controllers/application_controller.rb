# frozen_string_literal: true

class ApplicationController < ActionController::Base
    before_action :set_locale

    def set_locale
        I18n.locale = get_locale
    end

    def get_locale
        return @locale if @locale
        @locale = param_locale
        return @locale if @locale
        @locale = I18n.default_locale
        @locale
    end

    def param_locale
        l = params[:locale]
        return nil unless l
        return l.to_sym if I18n::available_locales.include?(l.to_sym)
        nil
    end

    def default_url_options(options={})
        options.merge(locale: locale)
    end
end
