type colors = {
  primary: string,
  primary75: string,
  primary50: string,
  primary25: string,
  danger: string,
  dangerLight: string,
  neutral0: string,
  neutral5: string,
  neutral10: string,
  neutral20: string,
  neutral30: string,
  neutral40: string,
  neutral50: string,
  neutral60: string,
  neutral70: string,
  neutral80: string,
  neutral90: string,
}
type theme = {
  colors: colors
}
type optionValue = {"value": string, "label": string}
type onChange = (optionValue) => unit
type options = array<optionValue>
type reactSelectStyle = {
  control: (ReactDOM.Style.t) => ReactDOM.Style.t,
  menu: (ReactDOM.Style.t) => ReactDOM.Style.t,
}
type getStyleWithKey = (string, reactSelectStyle) => unit

@module("react-select") external reactSelectComponent: {..} = "components"
@module("react-select") external defaultTheme: {..} = "defaultTheme"

module ReactSelectOption = {
  type props = {children?: option<React.element>, label: string, value: string}
  let optionComponent: props => React.element = reactSelectComponent["Option"]

  let make = (props: props) => {
    <>{React.createElement(optionComponent, props)}</>
  }
}

module ReactSelectControl = {
  type props = {
    children: React.element,
    cx: () => unit,
    getClassNames: getStyleWithKey,
    getStyles: getStyleWithKey,
    theme
  }
  let controlComponent: props => React.element = reactSelectComponent["Control"]

  let make = (props: props) => {
    <>
      {React.createElement(controlComponent, props)}
    </>
  }
}

type components<'a> = {
  @as("Control") control?: ReactSelectControl.props => React.element,
  @as("DropdownIndicator") dropdownIndicator?: 'a => React.element,
  @as("IndicatorSeparator") indicatorSeparator?: 'a => React.element,
  @as("Option") option?: ReactSelectOption.props => React.element,
}

@react.component @module("react-select")
external make: (
  ~autoFocus: bool=?,
  ~backspaceRemovesValue: bool=?,
  ~className: string=?,
  ~controlShouldRenderValue: bool=?,
  ~components: components<'a>=?,
  ~hideSelectedOptions: bool=?,
  ~isClearable: bool=?,
  ~menuIsOpen: bool=?,
  ~onChange: onChange,
  ~options: options,
  ~placeholder: string=?,
  ~styles: reactSelectStyle=?,
  ~tabSelectsValue: bool=?,
  ~value: option<optionValue>=?
) => React.element = "default"
