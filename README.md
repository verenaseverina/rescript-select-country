# Notes
1. Currently for example to use, I use the interface from the given task so no event for changing the value, just logged it to console
```
<CountrySelect
  className="countrySelect"
  country=Some("us")
  onChange=(country => Js.log(country))
/>
```
2. Because of that, cannot clear the value using keyboard for requirement on point `It supports keyboard (user can open and close dropdown, navigate and select options, cancel choice with keyboard).`