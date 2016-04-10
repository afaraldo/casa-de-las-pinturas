class RadioGroupButtonsInput < SimpleForm::Inputs::CollectionRadioButtonsInput
  # Radio buttons personalizado para btn-group
  def input(wrapper_options)
    out = '<div class="btn-group" data-toggle="buttons">'
    label_method, value_method = detect_collection_methods
    collection.each do |item|
      value = item.send(value_method)
      label = item.send(label_method)
      checked = @builder.object[attribute_name] == value
      active = ''
      active = ' active' if checked
      input_html_options[:value] = value unless active.empty?
      btn = 'btn btn-default'
      out << "<label class='#{btn} #{active}'>"
        out << "<input type='radio' class='#{input_html_options[:class].join(' ')}' #{checked ? 'checked="checked"' : ''} value='#{value}' name='#{@builder.object.class.to_s.underscore}[#{attribute_name}]'>#{label}</input>"
      out << "</label>"
    end
    out << "</div>"
    out.html_safe
  end
end