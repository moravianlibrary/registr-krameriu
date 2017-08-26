class AnalyticsController < ApplicationController

  def increments
    if params[:library]
      library = Library.find_by(code: params[:library])
      @active_library_id = library.id
      @active_library_name = library.name
    end
    @libraries = Library.all.order(name: :asc)
  end

  def data
    data_interval = params[:interval]
    data_interval ||= "ty"

    if data_interval == "l7d"
      data_from = (Time.now - 7.days).beginning_of_day
      data_to = Time.now
    elsif data_interval == "l30d"
      data_from = (Time.now - 30.days).beginning_of_day
      data_to = Time.now
    elsif data_interval == "ly"
      data_from = (Date.today - 1.year).beginning_of_year
      data_to = data_from.end_of_year
    elsif data_interval == "lm"
      data_from = (Date.today - 1.month).beginning_of_month
      data_to = data_from.end_of_month
    elsif data_interval == "tm"
      data_from = Date.today.beginning_of_month
      data_to = Time.now
    elsif data_interval == "all"
    else
      # this year /ty
      data_from = Date.today.beginning_of_year
      data_to = Time.now
    end
    if data_interval == "all"
      data_range = nil
    else
      data_range = data_from..data_to
    end

    data_group = params[:group]
    data_group ||= "month"
    if data_group == "year"
      data_format = "%Y"
    elsif data_group == "day"
      data_format = "%d.%m.%Y"
    elsif data_group == "week"
      data_format = "%d %B"
    else
      data_group == "month"
      data_format = "%B %Y"
    end


    result = Record.all
    result = result.where(date: data_range) unless data_range.nil?
    if params[:library] && params[:library] != "all"
      result = result.where(library: params[:library])
    end

    documents_all = result.group_by_period(data_group, :date, range: data_range,  week_start: :mon, format: data_format).sum(:inc_documents_all)
    documents_public = result.group_by_period(data_group, :date, range: data_range,  week_start: :mon, format: data_format).sum(:inc_documents_public)
    pages_all = result.group_by_period(data_group, :date, range: data_range,  week_start: :mon, format: data_format).sum(:inc_pages_all)
    pages_public = result.group_by_period(data_group, :date, range: data_range,  week_start: :mon, format: data_format).sum(:inc_pages_public)

    overall_documents_all = result.sum(:inc_documents_all)
    overall_documents_public = result.sum(:inc_documents_public)
    overall_pages_all = result.sum(:inc_pages_all)
    overall_pages_public = result.sum(:inc_pages_public)



    render json: {
        "labels": pages_public.keys,
        "pages_public": pages_public.values,
        "documents_public": documents_public.values,
        "pages_all": pages_all.values,
        "pages_public": pages_public.values,

        "overall_documents_all": overall_documents_all,
        "overall_documents_public": overall_documents_public,
        "overall_pages_all": overall_pages_all,
        "overall_pages_public": overall_pages_public,
      }
  end



end
