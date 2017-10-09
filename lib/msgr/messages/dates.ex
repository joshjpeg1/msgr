defmodule Msgr.Dates do
	def get_msg_time(msg, curr_day, curr_time) do
		curr_utc = calc_utc(curr_time.hour, curr_time.minute, curr_time.second)
		msg_utc =  calc_utc(msg.hour, msg.minute, msg.second)
		sd_time_dif = curr_utc - msg_utc
		nd_time_dif = (86400 - msg_utc) + curr_utc
		
		same_month = (curr_day.month == msg.month) and ((curr_day.day < msg.day) or (curr_day.day == msg.day and (sd_time_dif < 0)))

		if (curr_day.year == msg.year) or ((curr_day.year - msg.year == 1) and (same_month or (curr_day.month < msg.month))) do

			next_day = ((curr_day.month == msg.month) and (curr_day.day - msg.day == 1))
			next_day = next_day or ((curr_day.month - msg.month == 1) and (curr_day.day - msg.day == 1))
			next_day = next_day or (curr_day.month == 1 and msg.month == 12 and curr_day.day == 1 and msg.day == Date.days_in_month(msg))
			
			same_day = (curr_day.month == msg.month) and (curr_day.day == msg.day)			
			
			# less than a day
			if ((sd_time_dif > 0) and same_day) or ((sd_time_dif < 0) and next_day) do
				# less than an hour
				if ((sd_time_dif < 3600) and same_day) or ((nd_time_dif < 3600) and next_day) do
					# less than a minute
					if ((sd_time_dif < 60) and same_day) or ((nd_time_dif < 60) and next_day) do
						"Just now"
					else
						date_in_minutes(same_day, sd_time_dif, nd_time_dif)
					end
				else
					date_in_hours(same_day, sd_time_dif, nd_time_dif)
				end
			else
				date_over_day(msg)
			end
		else
			date_over_year(msg)
		end
	end

	def date_in_minutes(same_day, sd_time_dif, nd_time_dif) do
		if same_day do
			"#{round(sd_time_dif / 60)}m"
		else
			"#{round(nd_time_dif / 60)}m"
		end
	end

	def date_in_hours(same_day, sd_time_dif, nd_time_dif) do
		if same_day do
      "#{round(sd_time_dif / 3600)}h"
    else
    	"#{round(nd_time_dif / 3600)}h"
		end
	end

	def date_over_day(msg) do
		"#{get_month_short(msg.month)} #{msg.day}"
	end

	def date_over_year(msg) do
		"#{msg.day} #{get_month_short(msg.month)} #{msg.year}"
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
