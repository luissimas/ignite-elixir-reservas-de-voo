defmodule Flightex do
  alias Flightex.Bookings.Report
  alias Flightex.Users.Agent, as: UserAgent
  alias Flightex.Bookings.Agent, as: BookingAgent
  alias Flightex.Users.CreateOrUpdate, as: CreateOrUpdateUser
  alias Flightex.Bookings.CreateOrUpdate, as: CreateOrUpdateBooking

  def start_agents do
    UserAgent.start_link(%{})
    BookingAgent.start_link(%{})
  end

  defdelegate create_or_update_user(params), to: CreateOrUpdateUser, as: :call
  defdelegate create_or_update_booking(params), to: CreateOrUpdateBooking, as: :call
  defdelegate generate_report(filename), to: Report, as: :generate
  defdelegate generate_report(from_date, to_date, filename), to: Report, as: :generate
end
