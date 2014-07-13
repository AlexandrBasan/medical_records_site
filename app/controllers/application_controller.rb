class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  # i18n multilanguage.
  before_action :set_locale
  # Mobile
  before_filter :prepare_for_mobile
  # Mobile

  def set_locale
    #I18n.locale = params[:locale] || I18n.default_locale
    if params[:locale]
      # Language switcher
      I18n.locale = params[:locale] || I18n.default_locale
    else
      I18n.locale = (http_accept_language.compatible_language_from(I18n.available_locales)) || (I18n.default_locale)
    end
#      if I18n.available_locales.include?(extract_locale_from_accept_language_header)
#        logger.debug "* Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']}"
#        I18n.locale = extract_locale_from_accept_language_header || I18n.default_locale
#        logger.debug "* Locale set to '#{I18n.locale}'"
#      else
#        I18n.default_locale
#      end
  end

  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end

# Mobile
  def mobile_device?
    if session[:mobile_param]
      session[:mobile_param] == "1"
    else
      request.user_agent =~ /Mobile|webOS/
    end
  end
  helper_method :mobile_device?

  def prepare_for_mobile
    session[:mobile_param] = params[:mobile] if params[:mobile]
    request.format = :mobile if mobile_device?
  end
# Mobile

  # remember user language choise in navigation process
  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    {locale: I18n.locale}
  end

  ###########################BOOTSTRAP ELEMENTS FOR ALL###########################
  require 'action_view/helpers/tags/base'
  # Most input types need the form-control class on them.  This is the easiest way to get that into every form input
  module BootstrapTag
    FORM_CONTROL_CLASS = 'form-control'

    def tag(name, options, *)
      options = add_bootstrap_class_to_options options, true if name.to_s == 'input'
      super
    end

    private

    def content_tag_string(name, content, options, *)
      options = add_bootstrap_class_to_options options if name.to_s.in? %w(select textarea)
      super
    end

    def add_bootstrap_class_to_options(options, check_type = false)
      options = {} if options.nil?
      options.stringify_keys!
      if !check_type || options['type'].to_s.in?(%w(text password number email))
        options['class'] = [] unless options.has_key? 'class'
        options['class'] << FORM_CONTROL_CLASS if options['class'].is_a?(Array) && !options['class'].include?(FORM_CONTROL_CLASS)
        options['class'] << " #{FORM_CONTROL_CLASS}" if options['class'].is_a?(String) && options['class'] !~ /\b#{FORM_CONTROL_CLASS}\b/
      end
      options
    end
  end

  ActionView::Helpers::Tags::Base.send :include, BootstrapTag
  ActionView::Base.send :include, BootstrapTag
  ###########################BOOTSTRAP ELEMENTS FOR ALL###########################

end
