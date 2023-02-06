type optionValue = {"value": string, "label": string}
type onChange = (string) => unit
type options = array<optionValue>

@module("react-select") external components: {..} = "components"

module ReactSelectOption = {
  type props = {label: string, value: string, children?: option<React.element>}
  let optionComponent: props => React.element = components["Option"]

  let make = (props: props) => {
    <>{React.createElement(optionComponent, props)}</>
  }
}

@react.component @module("react-select")
external make: (
  ~className: option<string>=?,
  ~components: {
    "Option": ReactSelectOption.props => React.element
  }=?,
  ~onChange: onChange,
  ~options: options,
  ~placeholder: string=?,
  ~value: option<string>=?
) => React.element = "default"
