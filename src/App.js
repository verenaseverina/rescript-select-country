// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as CountrySelect from "./CountrySelect.js";

function App(props) {
  return React.createElement("div", undefined, React.createElement(CountrySelect.make, {
                  className: "",
                  country: "us",
                  onChange: (function (val) {
                      console.log(val);
                    })
                }));
}

var make = App;

export {
  make ,
}
/* react Not a pure module */
