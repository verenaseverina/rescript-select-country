@react.component
let make = () => {
  let (countryValue, setCountryValue) = React.useState(_ => "us")

  let onChange = (val) => {
    setCountryValue(_ => val)
  }

  <div>
    <CountrySelect
      className="countrySelect"
      country=Some(countryValue)
      onChange
    />
  </div>
}