@react.component
let make = () => {
  <div>
    <CountrySelect
      className=""
      country=Some("us")
      onChange=((val) => Js.log(val))
    />
  </div>
}