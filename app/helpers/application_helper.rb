module ApplicationHelper

  def page_title
    unless @title.blank?
      @title << ' | Anicon'
    else
      @title = 'Anicon'
    end

    @title
  end


end
