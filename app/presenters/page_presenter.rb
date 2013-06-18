class PagePresenter < BasePresenter
  presents :page
  delegate :title, to: :page

  def updated_at
    page.updated_at.strftime("%d.%m.%y %H:%M")
  end

  def content
    markdown(page.content)
  end
end