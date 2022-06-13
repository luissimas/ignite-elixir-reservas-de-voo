defmodule Flightex.Bookings.Report do
  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Bookings.Booking

  def generate(filename \\ "report.csv") do
    bookings =
      BookingAgent.list()
      |> Map.values()
      |> build_bookings()

    File.write(filename, bookings)
  end

  def generate(from_date, to_date, filename \\ "report.csv") do
    bookings =
      BookingAgent.list()
      |> Map.values()
      |> Enum.filter(fn %Booking{complete_date: date} -> is_between?(date, from_date, to_date) end)
      |> build_bookings()

    File.write(filename, bookings)
  end

  defp is_between?(target, start_date, end_date) do
    case {Date.compare(target, start_date), Date.compare(target, end_date)} do
      {:gt, :lt} -> true
      {:gt, :eq} -> true
      {:eq, :lt} -> true
      {:eq, :eq} -> true
      _ -> false
    end
  end

  defp build_bookings(bookings), do: Enum.map(bookings, &stringify_booking/1)

  defp stringify_booking(%Booking{
         user_id: user_id,
         local_origin: local_origin,
         local_destination: local_destination,
         complete_date: complete_date
       }) do
    "#{user_id},#{local_origin},#{local_destination},#{complete_date}\n"
  end
end
