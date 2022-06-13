defmodule Flightex.Bookings.Report do
  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.Booking

  def generate(filename \\ "report.csv") do
    bookings = build_bookings()

    File.write(filename, bookings)
  end

  defp build_bookings() do
    BookingAgent.list()
    |> Map.values()
    |> Enum.map(&stringify_booking/1)
  end

  defp stringify_booking(%Booking{
         user_id: user_id,
         local_origin: local_origin,
         local_destination: local_destination,
         complete_date: complete_date
       }) do
    "#{user_id},#{local_origin},#{local_destination},#{complete_date}"
  end
end
