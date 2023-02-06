type method = [#GET]

module Response = {
  type t

  @send external text: t => Js.Promise2.t<string> = "text"
  @send external json: t => Js.Promise2.t<Js.Json.t> = "json"
}

@val external fetch: string => Js.Promise2.t<Response.t> = "fetch"