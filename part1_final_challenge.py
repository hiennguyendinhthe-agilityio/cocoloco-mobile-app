from __future__ import annotations


class SensorDataError(ValueError):
    """Raised when sensor data is missing or malformed."""


def process_sensor_batch(
    batch_name: str,
    *args: dict[str, object],
    error_logs: list[str] | None = None,
    **kwargs: object,
) -> list[float]:
    error_logs = error_logs if error_logs is not None else []
    valid_temps: list[float] = []

    for index, raw_data in enumerate(args, start=1):
        try:
            try:
                city = raw_data["city"]
                temp = float(raw_data["temp"])
            except KeyError as exc:
                raise SensorDataError(
                    f"Batch {batch_name}: record {index} missing key {exc.args[0]!r}"
                ) from exc
            except (TypeError, ValueError) as exc:
                raise SensorDataError(
                    f"Batch {batch_name}: record {index} bad temp value {raw_data.get('temp')!r}"
                ) from exc
        except SensorDataError as exc:
            error_logs.append(str(exc))
        else:
            valid_temps.append(temp)
            kwargs.setdefault("cities", []).append(city)

    if error_logs:
        print("Error logs:")
        for message in error_logs:
            print(f"- {message}")

    return valid_temps


def main() -> None:
    error_logs: list[str] = []
    cities: list[str] = []
    raw_batch = [
        {"city": "Hanoi", "temp": "32.5"},
        {"city": "Danang", "temp": "not_a_number"},
        {"temp": "15.0"},
        {"city": "Sapa", "temp": 15},
    ]

    valid_temps = process_sensor_batch(
        "weather_batch_01",
        *raw_batch,
        error_logs=error_logs,
        cities=cities,
    )

    for city, temp in zip(cities, valid_temps):
        print(f"{city}: {temp}")


if __name__ == "__main__":
    main()
