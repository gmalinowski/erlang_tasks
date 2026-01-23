-module(space_age).

-export([age/2]).

age(Planet, Seconds) -> 
    PassedSeconds = seconds_passed_on(Planet, Seconds),
    seconds_to_year(PassedSeconds).

seconds_passed_on(Planet, Seconds) -> Seconds / time_factor_on(Planet).

time_factor_on(mercury) -> 0.2408467;
time_factor_on(venus) -> 0.61519726;
time_factor_on(earth) -> 1.0;
time_factor_on(mars) -> 1.8808158;
time_factor_on(jupiter) -> 11.862615;
time_factor_on(saturn) -> 29.447498;
time_factor_on(uranus) -> 84.016846;
time_factor_on(neptune) -> 164.79132.

seconds_to_year(Seconds) -> Seconds / seconds_in_earth_year().

seconds_in_earth_year() -> 365.25 * 24 * 60 * 60.