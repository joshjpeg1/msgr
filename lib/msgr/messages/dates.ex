defmodule Msgr.Dates do
	
	def get_msg_time(msg, current) do
		curr_utc = calc_utc(current.hour, current.minute, current.second)
		msg_utc =  calc_utc(msg.hour, msg.minute, msg.second)
		sd_time_dif = curr_utc - msg_utc  # same day time difference
		nd_time_dif = (86400 - msg_utc) + curr_utc  # next day time difference
		
		same_month = (current.month == msg.month) and ((current.day < msg.day) or (current.day == msg.day and (sd_time_dif < 0)))

		if (current.year == msg.year) or ((current.year - msg.year == 1) and (same_month or (current.day < msg.day))) do
			check_less_than_day(msg, current, sd_time_dif, nd_time_dif)
		else
			date_over_year(msg)
		end
	end

	def check_less_than_day(msg, current, sd_time_dif, nd_time_dif) do
		next_day = ((current.month == msg.month) and (current.day - msg.day == 1))
    next_day = next_day or ((current.month - msg.month == 1) and (current.day - msg.day == 1))
    next_day = next_day or (current.month == 1 and msg.month == 12 and current.day == 1 and msg.day == Date.days_in_month(msg))

    same_day = (current.month == msg.month) and (current.day == msg.day)

		if ((sd_time_dif >= 0) and same_day) or ((sd_time_dif < 0) and next_day) do
			check_less_than_hour(same_day, next_day, sd_time_dif, nd_time_dif)
		else
			date_over_day(msg)
		end
	end

	def check_less_than_hour(same_day, next_day, sd_time_dif, nd_time_dif) do
		if ((sd_time_dif < 3600) and same_day) or ((nd_time_dif < 3600) and next_day) do
			check_less_than_minute(same_day, next_day, sd_time_dif, nd_time_dif)
		else
			date_in_hours(same_day, sd_time_dif, nd_time_dif)
		end
	end

	def check_less_than_minute(same_day, next_day, sd_time_dif, nd_time_dif) do
		if ((sd_time_dif < 60) and same_day) or ((nd_time_dif < 60) and next_day) do
			"Just now"
		else
			date_in_minutes(same_day, sd_time_dif, nd_time_dif)
		end
	end

	def date_over_year(msg) do
		"#{msg.day} #{get_month_short(msg.month)} #{msg.year}"
	end

	def date_over_day(msg) do
		"#{get_month_short(msg.month)} #{msg.day}"
	end
	
	def date_in_hours(same_day, sd_time_dif, nd_time_dif) do
		if same_day do
      "#{round(sd_time_dif / 3600)}h"
    else
    	"#{round(nd_time_dif / 3600)}h"
		end
	end
	
	def date_in_minutes(same_day, sd_time_dif, nd_time_dif) do
		if same_day do
			"#{round(sd_time_dif / 60)}m"
		else
			"#{round(nd_time_dif / 60)}m"
		end
	end

	def get_month_short(month) do
		cond do
			month == 1  -> "Jan"
			month == 2  -> "Feb"
			month == 3  -> "Mar"
			month == 4  -> "Apr"
			month == 5  -> "May"
			month == 6  -> "Jun"
			month == 7  -> "Jul"
			month == 8  -> "Aug"
			month == 9  -> "Sep"
			month == 10 -> "Oct"
			month == 11 -> "Nov"
			month == 12 -> "Dec"
		end
	end

	def calc_utc(hour, minute, sec) do
		sec + 60 * (minute + 60 * hour)
	end
end
