require "tailwind_merge"

module ApplicationHelper
  def cn(*args)
    TailwindMerge::Merger.new.merge(args.compact.join(" "))
  end
end
