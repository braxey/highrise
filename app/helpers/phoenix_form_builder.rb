class PhoenixFormBuilder < ActionView::Helpers::FormBuilder
  include ActionView::Helpers::TagHelper

  def label(attribute, options = {})
    classes = "text-sm leading-none font-medium select-none group-data-[disabled=true]:pointer-events-none " +
        "group-data-[disabled=true]:opacity-50 peer-disabled:cursor-not-allowed peer-disabled:opacity-50"

    super(attribute, options.merge(class: "#{classes} #{options[:class]}"))
  end

  %w[text_field email_field password_field].each do |method_name|
    define_method(method_name) do |attribute, options = {}|
      classes = "border-input file:text-foreground placeholder:text-muted-foreground " +
                "selection:bg-primary selection:text-primary-foreground flex h-9 w-full min-w-0 rounded-md border " +
                "bg-transparent px-3 py-1 text-base shadow-xs transition-[color,box-shadow] outline-none file:inline-flex " +
                "file:h-7 file:border-0 file:bg-transparent file:text-sm file:font-medium disabled:pointer-events-none " +
                "disabled:cursor-not-allowed disabled:opacity-50 md:text-sm focus-visible:border-ring " +
                "focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 " +
                "dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive"
      super(attribute, options.merge(class: "#{classes} #{options[:class]}"))
    end
  end

  def submit(attribute, options = {})
    classes = "inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium transition-[color,box-shadow] disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg:not([class*='size-'])]:size-4 [&_svg]:shrink-0 outline-none focus-visible:border-ring focus-visible:ring-ring/50 focus-visible:ring-[3px] aria-invalid:ring-destructive/20 dark:aria-invalid:ring-destructive/40 aria-invalid:border-destructive"

    variant = options[:variant]
    size = options[:size] || "default"

    if variant
      classes += case variant
      when "default" then " bg-primary text-primary-foreground shadow-xs hover:bg-primary/90"
      when "destructive" then " bg-destructive text-white shadow-xs hover:bg-destructive/90 focus-visible:ring-destructive/20 dark:focus-visible:ring-destructive/40"
      when "outline" then " border border-input bg-background shadow-xs hover:bg-accent hover:text-accent-foreground"
      when "secondary" then " bg-secondary text-secondary-foreground shadow-xs hover:bg-secondary/80"
      when "ghost" then " hover:bg-accent hover:text-accent-foreground"
      when "link" then " text-primary underline-offset-4 hover:underline"
      else ""
      end
    end

    if size
      classes += case size
      when "default" then " h-9 px-4 py-2 has-[>svg]:px-3"
      when "sm" then " h-8 rounded-md px-3 has-[>svg]:px-2.5"
      when "lg" then " h-10 rounded-md px-6 has-[>svg]:px-4"
      when "icon" then " size-9"
      else ""
      end
    end

    super(attribute, options.merge(class: "#{classes} #{options[:class]}"))
  end

  def input_error(attribute, options = {})
    classes = "text-sm text-red-600"
    tag.p(options[:message], class: [ classes, options[:class] ].compact.join(" "))
  end
end
