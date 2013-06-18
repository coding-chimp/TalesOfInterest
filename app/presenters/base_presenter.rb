class BasePresenter
  def initialize(object, template)
    @object = object
    @template = template
  end

private

  def self.presents(name)
    define_method(name) do
      @object
    end
  end

  def h
    @template
  end

  def markdown(text)
    Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(:hard_wrap => true), :space_after_headers => true, :autolink => true).render(text).html_safe
  end
end