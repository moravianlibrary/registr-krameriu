

class Api::StatesController < Api::ApiController
  
  def library

    library = Library.find_by(code: params[:id])
    if params[:int] == "5h"
      from = Time.now - 5.hours
      to = Time.now
    elsif params[:int] == "24h"
      from = Time.now - 24.hours
      to = Time.now
    elsif params[:int] == "7d"
      from = Time.now - 7.days
      to = Time.now
    elsif params[:int] == "1m"
      from = Time.now - 1.month
      to = Time.now
    elsif params[:int] == "6m"
      from = Time.now - 6.months
      to = Time.now
    elsif params[:int] == "1y"
      from = Time.now - 1.year
      to = Time.now
    else
      from = params[:from] ? Time.at(params[:from].to_i) : nil
      to = params[:to] ? Time.at(params[:to].to_i) : Time.now.to_datetime
    end

    states = State.where(library: library)
    states = states.where("at >= ?", from) if from
    states = states.where("at <= ?", to) if to
    states = states.order(at: :asc)

    first = State.where(library: library).order(at: :desc).where("at < ?", from).first
    first_value = first.nil? ? -1 : first.value

    values = []
    values << {
      t: from,
      v: first_value
    }
    states.each do |state|
      values << {
        t: state.at,
        v: state.value
      }
    end
    if to > Time.now
      values << {
        t: Time.now,
        v: -1
      }
    end
    result = {
      from: from,
      to: to,
      values: values
    }
    render json: result
  end

end