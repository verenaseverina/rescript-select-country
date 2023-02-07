open Belt
open Fetch
open Js.Promise2

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

@react.component
let make = (
  ~className: string,
  ~country: option<string>,
  ~onChange: onChange,
) => {
  let placeholder = switch country {
    | Some(country) => country
    | None => "Search"
  }
  let (options, setOptions) = React.useState(_ => [])

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

  <div>
    <ReactSelect
      className
      components=({ "Option": CustomOption.make })
      onChange=((value) => onChange(value["value"]))
      options
      placeholder
      value={getValueFromOption(country, options)} />
  </div>
}