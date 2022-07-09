defmodule Flightex.Bookings.ReportTest do
  use ExUnit.Case, async: true

  alias Flightex.Bookings.Report

  describe "generate/1" do
    setup do
      Flightex.start_agents()

      :ok
    end

    test "when called, return the content" do
      params = %{
        complete_date: ~N[2001-05-07 12:00:00],
        local_origin: "Brasilia",
        local_destination: "Bananeiras",
        user_id: "12345678900",
        id: UUID.uuid4()
      }

      content = "12345678900,Brasilia,Bananeiras,2001-05-07 12:00:00"

      Flightex.create_or_update_booking(params)
      Report.generate("report-test.csv")
      {:ok, file} = File.read("report-test.csv")

      assert file =~ content
    end

    test "when called with range, return the content" do
      params = [
        %{
          complete_date: ~N[2001-05-07 12:00:00],
          local_origin: "Brasilia",
          local_destination: "Bananeiras",
          user_id: "12345678900",
          id: UUID.uuid4()
        },
        %{
          complete_date: ~N[2001-05-11 12:00:00],
          local_origin: "Brasilia",
          local_destination: "Bananeiras",
          user_id: "12345678900",
          id: UUID.uuid4()
        }
      ]

      content = "12345678900,Brasilia,Bananeiras,2001-05-07 12:00:00"

      params
      |> Enum.map(&Flightex.create_or_update_booking/1)

      Report.generate(~N[2001-05-06 12:00:00], ~N[2001-05-08 12:00:00], "report-test.csv")
      {:ok, file} = File.read("report-test.csv")

      assert file =~ content
    end

    test "when called with range, return the content even in lower bound" do
      params = [
        %{
          complete_date: ~N[2001-05-07 12:00:00],
          local_origin: "Brasilia",
          local_destination: "Bananeiras",
          user_id: "12345678900",
          id: UUID.uuid4()
        },
        %{
          complete_date: ~N[2001-05-11 12:00:00],
          local_origin: "Brasilia",
          local_destination: "Bananeiras",
          user_id: "12345678900",
          id: UUID.uuid4()
        }
      ]

      content = "12345678900,Brasilia,Bananeiras,2001-05-07 12:00:00"

      params
      |> Enum.map(&Flightex.create_or_update_booking/1)

      Report.generate(~N[2001-05-07 12:00:00], ~N[2001-05-08 12:00:00], "report-test.csv")
      {:ok, file} = File.read("report-test.csv")

      assert file =~ content
    end

    test "when called with range, return the content even in upper bound" do
      params = [
        %{
          complete_date: ~N[2001-05-07 12:00:00],
          local_origin: "Brasilia",
          local_destination: "Bananeiras",
          user_id: "12345678900",
          id: UUID.uuid4()
        },
        %{
          complete_date: ~N[2001-05-11 12:00:00],
          local_origin: "Brasilia",
          local_destination: "Bananeiras",
          user_id: "12345678900",
          id: UUID.uuid4()
        }
      ]

      content = "12345678900,Brasilia,Bananeiras,2001-05-07 12:00:00"

      params
      |> Enum.map(&Flightex.create_or_update_booking/1)

      Report.generate(~N[2001-05-06 12:00:00], ~N[2001-05-07 12:00:00], "report-test.csv")
      {:ok, file} = File.read("report-test.csv")

      assert file =~ content
    end

    test "when called with range, return the content even in both bounds" do
      params = [
        %{
          complete_date: ~N[2001-05-07 12:00:00],
          local_origin: "Brasilia",
          local_destination: "Bananeiras",
          user_id: "12345678900",
          id: UUID.uuid4()
        },
        %{
          complete_date: ~N[2001-05-11 12:00:00],
          local_origin: "Brasilia",
          local_destination: "Bananeiras",
          user_id: "12345678900",
          id: UUID.uuid4()
        }
      ]

      content = "12345678900,Brasilia,Bananeiras,2001-05-07 12:00:00"

      params
      |> Enum.map(&Flightex.create_or_update_booking/1)

      Report.generate(~N[2001-05-07 12:00:00], ~N[2001-05-07 12:00:00], "report-test.csv")
      {:ok, file} = File.read("report-test.csv")

      assert file =~ content
    end
  end
end
