json.array!(@schedules) do |schedule|
  json.extract! schedule, :id, :customer_id, :customer_email, :date, :address, :note
  json.url schedule_url(schedule, format: :json)
end
