@react.component
let make = () => {
  <div>
    <CountrySelect
      className="countrySelect"
      country=Some("us")
      onChange=(country => Js.log(country))
    />
  </div>
}