module Controll
  module Notify
    TYPES = [:notice, :error, :warning, :success]

    autoload :Base,       'controll/notify/base'
    autoload :Flash,      'controll/notify/flash'
    autoload :Typed,      'controll/notify/typed'
    autoload :Macros,     'controll/notify/macros'
    autoload :Translator, 'controll/notify/translator'
    autoload :Message,    'controll/notify/message'
  end
end

module Notifiers
  Typed = Controll::Notify::Typed
end
