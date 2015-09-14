module MiddlemanToRails
  class Translator
    def initialize(template_text)
      @template_text = template_text
    end

    def translate
      translate_current_page_refs(
        translate_metadata(
          translate_partials(@template_text)
        )
      )
    end

    private

    def translate_current_page_refs(text)
      text.gsub(/current_page.data.(\w+)/) do |match|
        "content_for(:#{$1.to_sym})"
      end.gsub(/current_page.url/, 'request.path')
    end

    def translate_metadata(text)
      text.gsub(/---.*---/im) do |match|
        output = "<%\n"
        match.scan(/(\w+): (.*)$/) do |match|
          key = $1
          value = $2.gsub('\'','\\\'')
    
          output += "content_for(:#{key.to_sym}) do '#{value}' end\n"
        end
        output + "%>"
      end
    end

    def translate_partials(text)
      text.gsub(/partial ["'](.*)["']/) do |match|
        partial = $1.gsub('-', '_')
        "render partial: '#{partial}'"
      end
    end
  end
end
