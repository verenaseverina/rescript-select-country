%%raw("import 'flag-icons/css/flag-icons.min.css'")

@module("./FlagIcon.module.css") external flagIconStyle: {..} = "default"

@react.component
let make = (
    ~country: string
  ) => {
  <span className=`fi fi-${country} ${flagIconStyle["flagIcon"]}`></span>
}
