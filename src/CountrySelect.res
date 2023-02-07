open Belt
open Fetch
open Js.Promise2

@module("./CountrySelect.module.css") external countrySelectStyle: {..} = "default"

type onClose = () => unit

let controlStyle = ReactDOM.Style.make(~paddingLeft= "1rem", ())
let menuStyle = ReactDOM.Style.make(~boxShadow="inset 0 1px 0 rgba(0, 0, 0, 0.1)", ())
let selectStyles: ReactSelect.reactSelectStyle = {
  control: (props) => ReactDOM.Style.combine(props, controlStyle),
  menu: (_) => menuStyle,
};

module Svg = {
  @react.component
  let make = (~className: option<string>=?, ~children: React.element) => {
    <svg
      ?className
      width="24"
      height="24"
      viewBox="0 0 24 24"
      focusable="false"
      role="presentation"
    >
      {children}
    </svg>
  }
}

module DropdownIndicator = {
  @react.component
  let make = () => {
    <div className=countrySelectStyle["dropdownIndicator"]>
      <Svg>
        <path
          d="M16.436 15.085l3.94 4.01a1 1 0 0 1-1.425 1.402l-3.938-4.006a7.5 7.5 0 1 1 1.423-1.406zM10.5 16a5.5 5.5 0 1 0 0-11 5.5 5.5 0 0 0 0 11z"
          fill="currentcolor"
          fillRule="evenodd"
        />
      </Svg>
    </div>
  }
}

module ChevronDown = {
  @react.component
  let make = () => {
    <Svg className=countrySelectStyle["chevronRight"]>
      <path
        d="M8.292 10.293a1.009 1.009 0 0 0 0 1.419l2.939 2.965c.218.215.5.322.779.322s.556-.107.769-.322l2.93-2.955a1.01 1.01 0 0 0 0-1.419.987.987 0 0 0-1.406 0l-2.298 2.317-2.307-2.327a.99.99 0 0 0-1.406 0z"
        fill="currentColor"
        fillRule="evenodd"
      />
    </Svg>
  }
}

module Menu = {
  @react.component
  let make = (~children: React.element) => {
    <div className=countrySelectStyle["menu"]>{children}</div>
  }
}

module Blanket = {
  @react.component
  let make = (~onClick) => {
    <div className=countrySelectStyle["blanket"] onClick />
  }
}

module Dropdown = {
  @react.component
  let make = (
    ~children: React.element,
    ~isOpen: bool,
    ~target: React.element,
    ~onClose,
  ) => {
    let menuComponent = switch isOpen {
    | true => <Menu>{children}</Menu>
    | false => <></>
    }
    let blanketComponent = switch isOpen {
    | true => <Blanket onClick={onClose} />
    | false => <></>
    }
    <div className=countrySelectStyle["dropdownContainer"]>
      {target}
      {menuComponent}
      {blanketComponent}
    </div>
  }
}

module EmptyComponent = {
  let make = (props) => {
    <div {...props} />
  }
}

external convertToArray: Js.Json.t => array<'a> = "%identity"

module CustomOption = {
  let make = (props: ReactSelect.ReactSelectOption.props) => {
    let children = Some(
      <>
        <FlagIcon country={props.value} />
        {props.label->React.string}
      </>
    )
    <ReactSelect.ReactSelectOption {...props}>
      {children}
    </ReactSelect.ReactSelectOption>
  }
}

module CustomControl = {
  let make = (props: ReactSelect.ReactSelectControl.props) => {
    <ReactSelect.ReactSelectControl {...props}>
      <DropdownIndicator />
      {props.children}
    </ReactSelect.ReactSelectControl>
  }
}

let getValueFromOption = (keyword: option<string>, options: ReactSelect.options) => {
  let idx = ref(0)
  let break = ref(false)
  
  let key = switch keyword {
  | Some(val) => val
  | None => ""
  }

  while !break.contents && idx.contents < Array.length(options) && key !== "" {
    let currentOption = options[idx.contents]
    let isFound = switch currentOption {
    | Some(val) => val["value"] === key
    | None => false
    }
    if isFound {
      break := true
    } else {
      idx := idx.contents + 1
    }
  }

  switch break.contents {
  | true => options[idx.contents]
  | false => None
  }
}

type onChange = (string) => unit

let nullValue = Js.Nullable.null

@react.component
let make = (
  ~className: string,
  ~country: option<string>,
  ~onChange: onChange,
) => {
  let (isOpen, setIsOpen) = React.useState(() => false);
  let (options, setOptions) = React.useState(_ => [])

  let value = getValueFromOption(country, options)
  let name = switch value {
  | Some(value) => value["label"]
  | None => ""
  }
  let placeholder = switch country {
    | Some(_) => name
    | None => "Search..."
  }

  React.useEffect1(() => {
    fetch(
      "https://gist.githubusercontent.com/rusty-key/659db3f4566df459bd59c8a53dc9f71f/raw/4127f9550ef063121c564025f6d27dceeb279623/counties.json",
    )
    ->then(val => {
      Response.json(val)
        ->then(val => {
          setOptions(_ => convertToArray(val))
          resolve()
        })
    })
    ->ignore
    None
  }, [setOptions])

  <Dropdown
    isOpen
    onClose=(_ => setIsOpen(_ => false))
    target={
      <button onClick=((_) => setIsOpen(prev => !prev))>
        {name->React.string}
        <ChevronDown />
      </button>
    }
  >
    <ReactSelect
      autoFocus=true
      backspaceRemovesValue=false
      className
      components=({
        control: CustomControl.make,
        dropdownIndicator: EmptyComponent.make,
        indicatorSeparator: EmptyComponent.make,
        option: CustomOption.make,
      })
      controlShouldRenderValue=false
      hideSelectedOptions=false
      isClearable=false
      menuIsOpen=true
      onChange=(val => {
        onChange(val["value"])
        setIsOpen(_ => false)
      })
      onKeyDown=(_event => {
        if _event.key === "Escape" {
          setIsOpen(_ => false)
        }
      })
      options
      placeholder
      styles=selectStyles
      tabSelectsValue=false
      value
    />
  </Dropdown>
}