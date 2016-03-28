module SimpleForm
  module Components
    # Componente para agregar la clase apropiada a los campos dependiendo de la validacion definida en el modelo
    module InputRangeComponent
      # metodo principal
      def range_class(wrapper_options = nil)
        clase_rango = get_clase
        input_html_classes << clase_rango if clase_rango
        nil
      end

      # retorna la clase a partir de la validacion
      def get_clase
        validator = find_validator(:length)
        if validator && validator.options[:maximum]
          max = validator.options[:maximum]
          case max
            when 20
              'textoCorto'
            when 50
              'textoMedio'
            when 150
              'textoLargo'
            when 255
              'descripcion'
            else
              nil
          end
        else
          nil
        end
      end
    end
  end
end

SimpleForm::Inputs::Base.send(:include, SimpleForm::Components::InputRangeComponent)