class PhoenixFormBuilder < ActionView::Helpers::FormBuilder
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::CaptureHelper

  def label(attribute, options = {})
    classes = "text-sm leading-none font-medium select-none group-data-[disabled=true]:pointer-events-none " +
        "group-data-[disabled=true]:opacity-50 peer-disabled:cursor-not-allowed peer-disabled:opacity-50"

    super(attribute, options.merge(class: @template.cn(classes, options[:class])))
  end

  %w[text_field email_field password_field].each do |method_name|
    define_method(method_name) do |attribute, options = {}|
      classes = "border-input file:text-foreground placeholder:text-muted-foreground " +
                "selection:bg-primary selection:text-primary-foreground flex h-9 w-full min-w-0 rounded-md border " +
                "bg-transparent px-3 py-1 text-base shadow-xs transition-[color,box-shadow] outline-none file:inline-flex " +
                "file:h-7 file:border-0 file:bg-transparent file:text-sm file:font-medium disabled:pointer-events-none " +
                "disabled:cursor-not-allowed disabled:opacity-50 md:text-sm focus-visible:border-ring " +
                "focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 " +
                "aria-invalid:border-destructive"
      super(attribute, options.merge(class: @template.cn(classes, options[:class])))
    end
  end

  def submit(attribute, options = {})
    classes = options[:class] || ""
    variant = options[:variant] || "default"
    size = options[:size] || "default"

    super(attribute, options.merge(class: @template.button_classes(classes, variant, size)))
  end

  def dropdown(attribute, options = {})
    button_classes = "w-full flex justify-between items-center text-sm rounded-lg border border-neutral-300 bg-white px-3 py-2 text-neutral-900 transition focus:border-emerald-500 focus:ring-2 focus:ring-emerald-200 focus:outline-none cursor-pointer"
    menu_classes = "hidden absolute z-10 w-full mt-1 bg-white border border-neutral-200 rounded-lg shadow-lg"
    option_classes = "w-full px-3 py-2 text-sm text-left text-neutral-900 hover:bg-emerald-50 hover:text-emerald-600 capitalize transition-colors cursor-pointer"

    button_classes = @template.cn(button_classes, options[:button_class]) if options[:button_class]
    menu_classes = @template.cn(menu_classes, options[:menu_class]) if options[:menu_class]
    option_classes = @template.cn(option_classes, options[:option_class]) if options[:option_class]

    options[:include_blank] = false unless options.key?(:include_blank)
    selected_value = object.send(attribute) || options[:default]

    @template.content_tag(:div, data: { controller: "dropdown" }, class: "relative") do
      @template.concat(hidden_field(attribute, value: selected_value, required: options[:required], data: { dropdown_target: "input" }))
      @template.concat(@template.content_tag(:button, type: "button", data: { action: "dropdown#toggle" }, class: button_classes, "aria-expanded": "false", "aria-controls": "dropdown-menu-#{attribute}") do
        @template.concat(@template.content_tag(:span, data: { dropdown_target: "selected" }, class: "capitalize") do
          selected_value ? selected_value.humanize : "Select #{attribute.to_s.humanize.downcase}"
        end)
        @template.concat(@template.content_tag(:svg, class: "w-4 h-4 text-neutral-500", fill: "none", stroke: "currentColor", viewBox: "0 0 24 24") do
          @template.content_tag(:path, nil, "stroke-linecap": "round", "stroke-linejoin": "round", "stroke-width": "2", d: "M19 9l-7 7-7-7")
        end)
      end)
      @template.concat(@template.content_tag(:div, data: { dropdown_target: "menu" }, id: "dropdown-menu-#{attribute}", class: menu_classes) do
        options[:options].each do |label, value|
          @template.concat(@template.content_tag(:button, label, type: "button", data: { action: "dropdown#select", value: value, label: label }, class: option_classes))
        end
      end)
    end
  end

  def input_error(attribute, options = {})
    classes = "text-sm text-red-600"
    tag.p(options[:message], class: @template.cn(classes, options[:class]))
  end
end
