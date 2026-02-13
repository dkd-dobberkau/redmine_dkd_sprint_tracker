require 'date'

class DkdSprintCalculator
  SPRINT_WEEKS = 2
  WORKING_WEEKDAYS = [1, 2, 3, 4, 5].freeze # Mon-Fri
  CALENDAR_DAYS_PER_SPRINT = SPRINT_WEEKS * 7
  WORKING_DAYS_PER_SPRINT = SPRINT_WEEKS * WORKING_WEEKDAYS.size

  SprintInfo = Struct.new(
    :number, :start_date, :end_date, :current_day,
    :total_days, :non_working_day?, :week_in_sprint, :total_weeks,
    :progress, :remaining_days, :label,
    keyword_init: true
  )

  def self.current_sprint(date = Date.today)
    epoch = first_monday_of_year(date.year)

    # Falls vor dem ersten Montag des Jahres: vorheriges Jahr verwenden
    epoch = first_monday_of_year(date.year - 1) if date < epoch

    days_since_epoch = (date - epoch).to_i
    days_since_epoch = [0, days_since_epoch].max

    sprint_index = days_since_epoch / CALENDAR_DAYS_PER_SPRINT
    calendar_day_in_sprint = days_since_epoch % CALENDAR_DAYS_PER_SPRINT

    sprint_start = epoch + (sprint_index * CALENDAR_DAYS_PER_SPRINT)
    sprint_end = sprint_start + last_working_day_offset(sprint_start)

    work_day = count_working_days(sprint_start, calendar_day_in_sprint)
    work_day = [[1, work_day].max, WORKING_DAYS_PER_SPRINT].min

    current_weekday = (sprint_start + calendar_day_in_sprint).cwday
    is_non_working = !WORKING_WEEKDAYS.include?(current_weekday)

    working_days_per_week = WORKING_WEEKDAYS.size
    week_in_sprint = ((work_day - 1) / working_days_per_week) + 1

    kw_start = sprint_start.cweek
    kw_end = sprint_end.cweek
    iso_year = sprint_start.cwyear
    label = format('%d-KW%02d-KW%02d', iso_year, kw_start, kw_end)

    SprintInfo.new(
      number: sprint_index + 1,
      start_date: sprint_start,
      end_date: sprint_end,
      current_day: work_day,
      total_days: WORKING_DAYS_PER_SPRINT,
      "non_working_day?": is_non_working,
      week_in_sprint: week_in_sprint,
      total_weeks: SPRINT_WEEKS,
      progress: work_day.to_f / WORKING_DAYS_PER_SPRINT,
      remaining_days: WORKING_DAYS_PER_SPRINT - work_day,
      label: label
    )
  end

  def self.first_monday_of_year(year)
    # ISO 8601: Woche 1, Montag
    Date.commercial(year, 1, 1)
  end

  def self.last_working_day_offset(sprint_start)
    (CALENDAR_DAYS_PER_SPRINT - 1).downto(0) do |offset|
      day = sprint_start + offset
      return offset if WORKING_WEEKDAYS.include?(day.cwday)
    end
    CALENDAR_DAYS_PER_SPRINT - 1
  end

  def self.count_working_days(sprint_start, calendar_day_in_sprint)
    count = 0
    (0..calendar_day_in_sprint).each do |d|
      day = sprint_start + d
      count += 1 if WORKING_WEEKDAYS.include?(day.cwday)
    end
    count
  end

  private_class_method :last_working_day_offset, :count_working_days
end
