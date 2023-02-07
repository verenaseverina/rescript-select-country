%%raw("import 'flag-icons/css/flag-icons.min.css'")

@react.component
let make = (~country: string) => {
  <span className=`fi fi-${country}`></span>
}
