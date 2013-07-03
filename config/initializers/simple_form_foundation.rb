# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  config.wrappers :default, class: :input, hint_class: :field_with_hint, error_class: :error do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :label_input
    b.use :error, wrap_with: { tag: :small, class: :error }

    # Uncomment the following line to enable hints. The line is commented out by default since Foundation
    # does't provide styles for hints. You will need to provide your own CSS styles for hints.
    # b.use :hint,  :wrap_with => { :tag => :span, :class => :hint }
  end

  config.wrappers :inline, class: :input, hint_class: :field_with_hint, error_class: :error do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.optional :readonly
    b.use :error, wrap_with: { tag: :small, class: :error }
    b.wrapper tag: 'div', class: 'row' do |ba|
      ba.use :label, class: 'small-3 columns'
      ba.wrapper tag: 'div', class: 'small-9 columns' do |bc|
        bc.use :input
        bc.use :hint, wrap_with: { tag: :span, class: :hint }
      end
    end
  end

  # The default wrapper to be used by the FormBuilder.
  config.default_wrapper = :inline

  # Define the way to render check boxes / radio buttons with labels.
  #   :inline => input + label
  #   :nested => label > input
  config.boolean_style = :inline

  # CSS class for buttons
  config.button_class = 'button'

  # CSS class to add for error notification helper.
  config.error_notification_class = 'error'

  # You can define the class to use on all forms. Default is simple_form.
  config.form_class = :custom

  # Default size for text inputs.
  config.default_input_size = 30

  config.label_class = 'inline right'
end